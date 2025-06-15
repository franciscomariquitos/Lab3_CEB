function analyse_transfer_function(data)
    % 1) Prep figure
    figure; set(gcf,'Color','w','Position',[100,100,800,400]);
    hold on; grid on; grid minor;

    % 2) Sort & aggregate
    x = data(:,1);  y = data(:,3);
    [xs,I] = sort(x); ys = y(I);
    [xu,~,ic] = unique(xs);
    yu = accumarray(ic,ys,[],@mean);

    % 3) Interpolate for smoothness
    xi = linspace(min(xu), max(xu), 1000);
    yi = interp1(xu,yu,xi,'pchip');

    % 4) Compute VOL & VOH
    Ys  = sort(yu);
    n   = round(0.25 * numel(yu));
    VOL = mean(Ys(1:n));
    VOH = mean(Ys(end-n+1:end));

    % 5) Plot transfer curve
    plot(xi, yi, '-', 'Color',[0 0.24 0.33], 'LineWidth',1.75, 'DisplayName','$v_O(v_I)$');

    % 6) Horizontal rails
    yline(VOH,'--k','LineWidth',1.5,'HandleVisibility','off');
    yline(VOL,'--k','LineWidth',1.5,'HandleVisibility','off');

    % 7) Compute discrete slopes
    slopes = diff(yi) ./ diff(xi);   % length = 999

    % 8) Find the single global minimum (steepest)
    [~, idx_min] = min(slopes);

    % 9) Find all crossings of slope = -1
    s = slopes + 1;
    crossings = find(s(1:end-1).*s(2:end) < 0);  
    % crossings gives indices i where slope(i) and slope(i+1) straddle -1

    % 10) Pick the crossing just before idx_min for VIL,
    %     and just after idx_min for VIH
    left_xings  = crossings(crossings < idx_min);
    right_xings = crossings(crossings > idx_min);
    if isempty(left_xings) || isempty(right_xings)
        error('Unable to find distinct left/right crossings near the steepest point.');
    end
    iL = left_xings(end);
    iH = right_xings(1);

    % 11) Linearly interpolate to exact x where slope = -1
    %    slope(iL)   = m1, slope(iL+1) = m2
    m1 = slopes(iL);
    m2 = slopes(iL+1);
    tL = ( -1 - m1 ) / (m2 - m1);
    xkL = xi(iL) + tL*(xi(iL+1)-xi(iL));
    ykL = yi(iL) + tL*(yi(iL+1)-yi(iL));

    m1 = slopes(iH);
    m2 = slopes(iH+1);
    tH = ( -1 - m1 ) / (m2 - m1);
    xkH = xi(iH) + tH*(xi(iH+1)-xi(iH));
    ykH = yi(iH) + tH*(yi(iH+1)-yi(iH));

    % 12) Mark the knee points
    plot(xkL, ykL, 'o', 'MarkerEdgeColor',[0 0.24 0.33], ...
         'MarkerFaceColor',[0 0.24 0.33], 'MarkerSize',6,'HandleVisibility','off');
    plot(xkH, ykH, 'o', 'MarkerEdgeColor',[0 0.24 0.33], ...
         'MarkerFaceColor',[0 0.24 0.33], 'MarkerSize',6,'HandleVisibility','off');

    % 13) Dotted‐blue tangents (one‐sided)
    m = -1; lt = 2.5;
    xx = linspace(xkL, xkL+lt, 40);
    plot(xx, ykL + m*(xx-xkL),':','Color',[0 0.24 0.33],'LineWidth',1,'HandleVisibility','off');
    xx = linspace(xkH-lt, xkH, 40);
    plot(xx, ykH + m*(xx-xkH),':','Color',[0 0.24 0.33],'LineWidth',1,'HandleVisibility','off');

    % 14) Short red slope=-1 segments
    lr = 1.0;
    xx = linspace(xkL-lr/2, xkL+lr/2,20);
    plot(xx, ykL + m*(xx-xkL),'r','LineWidth',2,'HandleVisibility','off');
    xx = linspace(xkH-lr/2, xkH+lr/2,20);
    plot(xx, ykH + m*(xx-xkH),'r','LineWidth',2,'HandleVisibility','off');

  

    % 15) Annotate the two knees just to the right
    text(xkL+0.02, ykL, sprintf('$V_{IL}=%.3f\\,\\mathrm{V}$',xkL), ...
         'Interpreter','latex','FontSize',9,'HorizontalAlignment','left','VerticalAlignment','bottom');
    text(xkH+0.02, ykH + 0.1, sprintf('$V_{IH}=%.3f\\,\\mathrm{V}$',xkH), ...
         'Interpreter','latex','FontSize',9,'HorizontalAlignment','left','VerticalAlignment','bottom');


    % 16) VOH/VOL text‐boxes
     text(0.2, VOH + 0.05, ...
         sprintf('$V_{OH}=%.3f\\,\\mathrm{V}$', VOH), ...
         'Interpreter','latex','FontSize',9, ...
         'HorizontalAlignment','left', 'VerticalAlignment','bottom');

    % Place VOL label just below its rail, right-aligned at V_I≈4.8V
    text(4.8, VOL - 0.05, ...
         sprintf('$V_{OL}=%.3f\\,\\mathrm{V}$', VOL), ...
         'Interpreter','latex','FontSize',9, ...
         'HorizontalAlignment','right','VerticalAlignment','top');


    % 17) Legend & axes
    legend('Interpreter','latex','Location','southwest');
    ax = gca; ax.XLim=[0 5]; ax.YLim=[-1 6];
    xticks(0:0.5:5);    yticks(-1:1:6);
    xticklabels(arrayfun(@(v)sprintf('%.1fV',v),0:0.5:5,'Uni',false));
    yticklabels(arrayfun(@(v)sprintf('%dV',v),-1:1:6,'Uni',false));
    xlabel('$V_I$','Interpreter','latex');
    ylabel('$V_O$','Interpreter','latex');

    hold off;
end
