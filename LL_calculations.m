% This script was written by Gard Hillestad for his project assignment, the
% fall of 2015. The intention is to understand the outputs from logplot.m.
% The script should be ran through the GUI LL_GUI, to be able to change
% inputs and outputs efficiently.

% TODOS:
% - Change variable names so that they are more coherent.


MA_opt_norm_bhut_jun15_20_10 = MA_opt_norm_bhut_jun15_20_10(find(MA_opt_norm_bhut_jun15_20_10(:,1)),:);


%% Determining Run Mode from GUI

% MODE 1, fixed Battery / PV set
% 1 = using set values of PV, size and battery size
% if no matching values are found only errormsg is displayed.
foundValue = false;
if( LL_gui_runmode == 1)
    for i = 1:length(MA_opt_norm_bhut_jun15_20_10)
        if( MA_opt_norm_bhut_jun15_20_10(i,3:4) == [pv_size batt_size] )
            NPV_target = MA_opt_norm_bhut_jun15_20_10(i, 2);
            foundValue = true;
        end
    end
end

% MODE 2, fixed target NPV value
% 2 = using a target budget from the calculated opt value matrix
% If no value within acceptance range is found errormsg is displayed
if( LL_gui_runmode == 2)
    for i = 1:length(MA_opt_norm_bhut_jun15_20_10)
        if( (NPV_target - MA_opt_norm_bhut_jun15_20_10(i,2) < 600e+1) &&...
                (NPV_target - MA_opt_norm_bhut_jun15_20_10(i,2) > 0))
            pv_size = MA_opt_norm_bhut_jun15_20_10(i,3);
            batt_size = MA_opt_norm_bhut_jun15_20_10(i,4);
            foundValue = true;
        end
    end
end

% IF no values match the ones in the MA_opt_sollution.....
if(foundValue == false)
    if(LL_gui_runmode == 1)
        disp('------------------------------')
        disp('ERROR')
        disp(['No matching value found for PV size = ' num2str(pv_size) ...
            ', and battery size = ' num2str(batt_size)])
        disp('------------------------------')
        error(['No matching value found for PV size = ' num2str(pv_size) ...
            ', and battery size = ' num2str(batt_size)])
    end
    % chosing max or min NPV available
    if(NPV_target > MA_opt_norm_bhut_jun15_20_10(1,1))
       warning(['Chosen NPV_target is out of range of optimal sollutions available,' ...
           'choosing maximal opt sollution for calculation'])
        pv_size = MA_opt_norm_bhut_jun15_20_10(1,3);
        batt_size = MA_opt_norm_bhut_jun15_20_10(1,4);
        NPV_target = MA_opt_norm_bhut_jun15_20_10(1,1);
    elseif(NPV_target < MA_opt_norm_bhut_jun15_20_10(end,1))      
        warning(['Chosen NPV_target is lower than optimal solutions available,' ...
           'choosing minimal NPV sollution for calculation'])
        pv_size = MA_opt_norm_bhut_jun15_20_10(end,3);
        batt_size = MA_opt_norm_bhut_jun15_20_10(end,4);
        NPV_target = MA_opt_norm_bhut_jun15_20_10(end,1);
    else
        disp('------------------------------')
        disp('ERROR')
        disp(['No matching value found for NPV = ' num2str(NPV_target)])
        disp('Try scrutinizing the search algorithm in LL_calculations.m')
        disp('------------------------------')
        error(['No matching value found for NPV = ' num2str(NPV_target)])
    end
end
            
disp(NPV_target)
disp(batt_size)
disp(pv_size)

% finding component indicies in the LL list.
batt_i = ((batt_size - min_batt) / step_batt +1);
pv_i = ((pv_size - min_PV) / step_PV +1);
budget_left = budget - NPV_target;

%% Preamble/ initiating constants
hours_in_one_week = 24*7;
hours_in_months = 24.*[31 28 31 30 31 30 31 31 30 31 30 31];
hours_passed_this_month = 0;
this_month = 1;
this_week = 1;
this_day = 1;

LL_time = 0;                    % LL timer
LL_longest_time = 0;            % worst case offline time
LL_times_occured = 0;           % how many times we loose power

LL_kWh_hourly_differences = 0;
LL_kWh_summed_rates = 0;
LL_kWh_rate_worstcase = 0;
LL_kWh_diff = 0;
positive_rate_counter = 0;

LL_daily_kWh = 0;
LL_weekly_kWh = 0;
LL_monthly_kWh = 0;

LL_default_daily = zeros(1,365);
LL_default_monthly = zeros(1,12);
LL_default_weekly = zeros(1,52);

LL_kW_unmet = 0;
LL_kW_unmet_worst = 0;
LL_kW_unmet_longest = 0;

time_of_longest_offline = 0;
time_of_largest_default = 0;
time_of_fastest_default_rate = 0;

LL_total_time = length(LL(:,batt_i, pv_i))-histc(LL(:,batt_i, pv_i),0); %total offline time
LL_kWh_default_year = sum(LL(:,batt_i, pv_i)); % Sums the energy default of one year


%% Default calculations
% This part generally segments up the different defaults by periods of
% which they occur, and then find some different statistics like if some
% weeks are worse, or how the worst case LL looks like in terms of kWh

prev_element_nonzero = false;
for i = 1:length(LL(:, batt_i, pv_i))
    LL_kWh = LL(i,batt_i,pv_i); 
    
    if(LL_kWh > 0)                                          % Checking whether a loss of load period is occuring
        
                                                            % Checking what rates of change occur
        if i > 1
           LL_kWh_diff = LL_kWh-LL(i-1,batt_i, pv_i);
           if LL_kWh_diff > 0
               if LL_kWh_diff > LL_kWh_rate_worstcase
                   LL_kWh_rate_worstcase = LL_kWh_diff;
                   time_of_fastest_default_rate = i;
               end
               LL_kWh_summed_rates = LL_kWh_summed_rates + LL_kWh_diff;
               positive_rate_counter = positive_rate_counter +1;
           end
        end
        
                                                            % Summing up the defaults of the ongoing period
        LL_kW_unmet = LL_kW_unmet + LL_kWh;                 % Adding to amount of default this period
        LL_time = LL_time +1;                               % Timing the duration of this period 
        
                                                            % Adding to the daily, weekly and monthly defaults
        LL_daily_kWh = LL_daily_kWh +LL_kWh;       
        LL_weekly_kWh = LL_weekly_kWh + LL_kWh;
        LL_monthly_kWh = LL_monthly_kWh + LL_kWh;
        prev_element_nonzero = true;                        % Controlbit for checking ended period of LL   
       
    else                                                    % If no LoL is occuring.
        if prev_element_nonzero == true;                    % Checking if a period LoL has ended on this iteration          
            LL_times_occured = LL_times_occured +1;         % Counting the number of LoL periods   
            if LL_time > LL_longest_time                    % Checking if this period was the longest one
                LL_longest_time = LL_time;
                LL_kW_unmet_longest = LL_kW_unmet;
                time_of_longest_offline = i;                
            end
            
            if LL_kW_unmet > LL_kW_unmet_worst              % Checking if this period was the one with largest
                LL_kW_unmet_worst = LL_kW_unmet;            % total default.
                time_of_largest_default = i;    
            end            
            
            LL_kW_unmet = 0;                                % Resetting counters for periods
            LL_time = 0;
            
        end        
        prev_element_nonzero = false;    
    end
    
                                                            % Segmenting the default into days, weeks, months
    if mod(i,24)==0
        LL_default_daily(this_day) = LL_daily_kWh;
        this_day = this_day +1;
        LL_daily_kWh = 0;
    end
    if mod(i,hours_in_one_week)==0
        LL_default_weekly(this_week) = LL_weekly_kWh;
        this_week = this_week +1;
        LL_weekly_kWh = 0;
    end
    hours_passed_this_month = hours_passed_this_month +1;
    if hours_passed_this_month == hours_in_months(this_month)
        LL_default_monthly(this_month) = LL_monthly_kWh;
        this_month = this_month +1;
        LL_monthly_kWh = 0;
        hours_passed_this_month = 0;
    end
      
end
                                                                    % Averages
LL_average_time = LL_total_time / LL_times_occured;                 % The avg LoL period length
LL_kW_longest_avg_default = LL_kW_unmet_longest / LL_longest_time;  % The avg default during the longest LoL period
LL_kW_avg_default = sum(LL(:,batt_i, pv_i)) / LL_total_time;        % The avg default of all LoL periods
LL_kWh_rate_avg = LL_kWh_summed_rates / positive_rate_counter;      % The avg rate of increasing demand

%% Outputting calculations

months = ['Jan: '; 'Feb: '; 'Mar: '; 'Apr: '; 'May: '; 'Jun: ';...
     'Jul: '; 'Aug: '; 'Sep: '; 'Okt: '; 'Nov: '; 'Dec: '];

disp('=========================================================')
disp('SIMULATION DATA FOR ANALYSIS')
disp('=========================================================')
disp(['Optimal battery size [kWh] = ' num2str(batt_size)])
disp(['Optimal PV array size [kW] = ' num2str(pv_size)])
disp(['Budget = ' num2str(budget)])
disp(['NPV (actual cost) = ' num2str(NPV_target)])
disp(['Remaining avaiable funds = ' num2str(budget_left)])
disp(['Accepted LLP = ' num2str(100*LLP_opt) '%'])
disp(['Min/max battery = ' num2str(min_batt) '/' num2str(max_batt)])
disp(['Min/max PV = ' num2str(min_PV) '/' num2str(max_PV)])
disp(['Step PV = ' num2str(step_PV) '; Step battery = ' num2str(step_batt)]) %might slightly change optimal solution
disp('=========================================================')
disp(' ')
disp('Totals:')
disp(['Total time offline: ' num2str(LL_total_time)])
disp(['Total occurences offline: ' num2str(LL_times_occured)])
disp(['Total kWh default one year: ' num2str(LL_kWh_default_year)])
disp(' ')
if disp_avg
    disp('Averages:')
    disp(['Average time offline during LL period: ' num2str(LL_average_time)])
    disp(['Hourly average kW default during one LL period: ' num2str(LL_kW_avg_default)])
    disp(['Daily average default: ' num2str(LL_kWh_default_year/365) ' [kWh]'])
    disp(['Monthly average default: ' num2str(LL_kWh_default_year/12) ' [kWh]'])
    disp(['Weekly average default: ' num2str(LL_kWh_default_year/52) ' [kWh]'])
    disp(['Average increasing kW demand during LL period: ' num2str(LL_kWh_rate_avg)])
    disp(' ')
end
if disp_worst_case
    disp('Worst-Cases:')
    disp(['Largest kW demand during LL: ' num2str(max(LL(:,batt_i, pv_i)))...
         ' - at time: ' num2str(time_of_largest_default)])
    disp(['Longest time offline: ' num2str(LL_longest_time)...
        ' - at time: ' num2str(time_of_longest_offline)])
    disp(['Sum kWh during longest offline: ' num2str(LL_kW_unmet_longest)])
    [Largest_daily_default, Largest_daily_default_day] = max(LL_default_daily);
    disp(['Largest daily default: ' num2str(Largest_daily_default) ' - at day: '...
         num2str(Largest_daily_default_day)])
    [Largest_weekly_default, Largest_weekly_default_week] = max(LL_default_weekly);
    disp(['Largest weekly default: ' num2str(Largest_weekly_default) ' - at week: '...
         num2str(Largest_weekly_default_week)])
    [Largest_monthly_default, Largest_monthly_default_month] = max(LL_default_monthly);
    disp(['Largest monthly default in ' months(Largest_monthly_default_month,:) ...
        num2str(Largest_monthly_default)])
    disp(['Largest kW default during LL: ' num2str(LL_kW_unmet_worst)...
        ' - at time: ' num2str(time_of_largest_default)])
    disp(['Fastest increase in kW demand between hours: ' num2str(LL_kWh_rate_worstcase)])
    disp(' ')
end
if disp_gen_req
    disp('Generator Worst Case Supply Requirements: ')
    disp(['Running for 8 hours: ' num2str(Largest_daily_default/8) ' [kW]'])
    disp(['Running for 12 hours: ' num2str(Largest_daily_default/12) ' [kW]'])
    disp(['Running for 16 hours: ' num2str(Largest_daily_default/16) ' [kW]'])
    disp(['Running for 24 hours: ' num2str(Largest_daily_default/24) ' [kW]'])
    disp(' ')
    disp('Generator Average Case Supply Requirements: ')
    disp(['Running for 8 hours: ' num2str(LL_kW_avg_default/8) ' [kW]'])
    disp(['Running for 12 hours: ' num2str(LL_kW_avg_default/12) ' [kW]'])
    disp(['Running for 16 hours: ' num2str(LL_kW_avg_default/16) ' [kW]'])
    disp(['Running for 24 hours: ' num2str(LL_kW_avg_default/24) ' [kW]'])
    disp(' ')
end

%% Plotting

% This requires a change in logplot.m
% SoC_every_scenario = zeros(length(irr)+1, n_PV, n_batt); before 'for loops
% SoC_every_scenario(:,PV_i,batt_i) = SoC(:); right after optimization and
% before the hardcoded plotting part (ref temp. bad sollution line ~200)
if plot_SoC
    figure(3)    
    plot(ELPV(:,pv_i, batt_i) ./ batt_size + 1,'Color',[142 178 68] / 255)
    hold on
    plot(- LL(:,pv_i, batt_i) ./ batt_size + SoC_min,'Color',[255 91 60] / 255)
    hold on
    plot(SoC_every_scenario(:,pv_i, batt_i),'Color',[64 127 255] / 255)
    hold off
    xlabel('Time over the year [hour]')
    ylabel('Power refered to State of Charge of the battery')
    legend('Overproduction, not utilized', 'Loss of power', 'State of charge')
end

if plot_power_balance
    batt_balance_pos = subplus(batt_balance);
    figure(1)
    plot(Load,'Color',[72 122 255] / 255)
    hold on
    plot(P_pv,'Color',[255 192 33] / 255)
    hold on
    plot(batt_balance_pos,'Color',[178 147 68] / 255)
    hold off
    xlabel('Time over the year [hour]')
    ylabel('Energy [kWh]')
    title('Energy produced and estimated load profile over the year (2nd steps PV and Batt)')
    legend('Load profile','Energy from PV', 'Energy flow from battery')
end

% % integration of figure(1) to find rough LLP estimate
% free = min(Load, P_pv);                                         % energy for free, i.e. directly from PV without battery intervenience, is the area under this graph. 
%                                                                 % N.B. Assumption: both Load and P_pv are positive functions
% time = 1:length(irr);
% free_area = trapz(time, free);                                  % discrete integration using trapeziums. Might not be the best solution for non-linear data. See http://se.mathworks.com/help/matlab/math/integration-of-numeric-data.html
% area_to_batt = trapz(time, P_pv) - free_area;                   % by definition this should be positive
% area_load_needed_from_batt = trapz(time, Load) - free_area;     % by definition this should be positive
% 
% unmet_load = area_load_needed_from_batt - area_to_batt;
% unmet_load_perc = unmet_load / trapz(time, Load) * 100;          % equal to Loss of Load Probability. But rough estimate since only comparing totals of load and P_pv! And SoC at end of the day influences next day. (Negative means overproduction)
% 
% % plot functions for an average day in figure(2)
% nr_days = length(irr) / 24;                    
% Load_av = zeros(1,24);                              % vector for average daily Load
% P_pv_av = zeros(1,24);                              % vector for average daily P_pv
% batt_balance_pos_av = zeros(1,24);                  % vector for average daily batt_balance_pos. This is misleading since it is influenced by state of charge of previous days.
% for hour = 1:24                                     % iterate over all times 1:00, 2:00 etc.
% hours_i = hour : 24 : (nr_days - 1) * 24 + hour;    % range to pick the i-th hour of each day throughout the yearly data, i.e. 1:00 of 1 January, 1:00 of 2 January etc.
%     for k = hours_i
%         Load_av(hour) = Load_av(hour) + Load(k);
%         P_pv_av(hour) = P_pv_av(hour) + P_pv(k);
%         batt_balance_pos_av(hour) = batt_balance_pos_av(hour) + batt_balance_pos(k);
%     end
%     Load_av(hour) = Load_av(hour) / nr_days;
%     P_pv_av(hour) = P_pv_av(hour) / nr_days;
%     batt_balance_pos_av(hour) = batt_balance_pos_av(hour) / nr_days;
% end
% 
% figure(2)
% plot(Load_av,'Color',[72 122 255] / 255)
% hold on
% plot(P_pv_av,'Color',[255 192 33] / 255)
% hold on
% plot(batt_balance_pos_av,'Color',[178 147 68] / 255)
% hold off
% xlabel('Time over the day [hour]')
% ylabel('Energy [kWh]')
% title('Energy produced and estimated load profile of an average day (2nd steps PV and Batt)')
% legend('Load profile','Energy from PV', 'Energy flow in battery')


%% Biomass consumption estimates

if disp_biomass_req
    disp('Amount needed Pr month')
    disp('If utilizing: Sawdust')
    efficiency_kg_to_kWh = 10;
    kWh_per_kilo = 2.26;
    for m = 1:12
        disp([months(m,:) num2str((LL_default_monthly(m)/kWh_per_kilo)*efficiency_kg_to_kWh) ' kg'])
    end
    disp(['Total = ' num2str(sum((LL_default_monthly./kWh_per_kilo)*efficiency_kg_to_kWh))])
    disp(' ')
    disp('If utilizing: Maize')
    efficiency_kg_to_kWh = 10;
    kWh_per_kilo = 5.1;
    for m = 1:12
        disp([months(m,:) num2str((LL_default_monthly(m)/kWh_per_kilo)*efficiency_kg_to_kWh) ' kg'])
    end
    disp(['Total = ' num2str(sum((LL_default_monthly./kWh_per_kilo)*efficiency_kg_to_kWh))])
    disp(' ')

    disp('Needed kWh/month')
    for m = 1:12
        disp([months(m,:) num2str(LL_default_monthly(m)) ' kWh'])
    end
    disp(['Total = ' num2str(sum(LL_default_monthly))])
    disp(' ')
end

