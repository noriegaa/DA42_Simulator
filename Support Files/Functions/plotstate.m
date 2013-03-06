function plotstate(time,true,simu,parameter,plotname,testname)

fig = figure();

plot(time,[true(:,1) true(:,3)],'--k','LineWidth',1)
hold on
plot(time,true(:,2),'k','LineWidth',1)
plot(time,simu,'b','LineWidth',1)
xlabel('Time (s)')
ylabel(parameter)
title(testname,'FontWeight','bold');

saveas(fig,plotname,'pdf')

end