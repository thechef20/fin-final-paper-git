% Author Matt Chistolini
% Last Edited 4/9/21
%% Setup Section
clear; clc;
A = readtable("data/ESG_and_five_factors.csv");
%paremeters
n_upper = 60; %max number of months
n_lower = 12; %min number of months
%%

%individual stock var
stock_symbols_refrences = A{:,1};
individual_stock_return = A{:,2};
ESG_returns = A{:,3};
market_reutrns = A{:,4};
hml = A{:,5};
smb = A{:,6};
rmw = A{:,7};
cma = A{:,8};
individual_stock_market_cap= A{:,9};
cal_year = A{:,10};
mmonth = A{:,11};
%% Actual Code 

upper_counter =0;
lower_counter = 0;
pre_rank_matrix = nan(length(stock_symbols_refrences),13); %adjust the last term if you want to carry more values
for i =2:length(stock_symbols_refrences);
    current_stock = stock_symbols_refrences(i);
    next_stock =stock_symbols_refrences(i-1);
    r_and_m_name = [current_stock individual_stock_return(i) ESG_returns(i) market_reutrns(i) cma(i) hml(i) smb(i) rmw(i) individual_stock_market_cap(i) cal_year(i) mmonth(i)];%year and month and name
    
    if current_stock == next_stock
        if lower_counter-1 >= n_lower
            if upper_counter > n_upper
                upper_counter = n_upper;
            end
            %indexing seems sus!! 4/9/21
            market = [market_reutrns(i-n_lower-upper_counter:i) market_reutrns(i-n_lower-upper_counter-1:i-1)];
            ESG_retun_data = [ESG_returns(i-n_lower-upper_counter:i) ESG_returns(i-n_lower-upper_counter-1:i-1)];
            individual = [individual_stock_return(i-n_lower-upper_counter:i)]; 
            beta_market = regress(individual , market)';
            beta_ESG = regress(individual , ESG_retun_data)';
            sum_o_beta_market = sum(beta_market);
            sum_o_beta_ESG = sum(beta_ESG);
            pre_rank_matrix(i,:)= [r_and_m_name sum_o_beta_market sum_o_beta_ESG];
            upper_counter = upper_counter + 1; 
        else
            pre_rank_matrix(i,:)= [r_and_m_name NaN NaN];
        end
        
        lower_counter = lower_counter+1;
    else
        pre_rank_matrix(i,:)= [r_and_m_name NaN NaN];
        upper_counter =0;
        lower_counter = 0;
    end
    
    
    
end 
%%
pre_rank_table = array2table(pre_rank_matrix,'VariableNames',{'kypermno','expected_return_stock','esg_minus_rf','market_minus_rf','hml','smb','rmw','cma','tcap','cal_year','mmonth','pre_ranked_beta_market','pre_ranked_esg'});%we changed myear to annual because of the porflio data uses annual
writetable( pre_rank_table, 'data/pre_rank_table.csv')

