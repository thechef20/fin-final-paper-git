function f = stage_one_reg(A,output_option)
%upgrade to MLS https://www.mathworks.com/help/stats/fitlm.html
%defining parameters
porflio_number = A{:,3};
expected_return_stock = A{:,4};
hml = A{:,5};
smb = A{:,6};
rmw = A{:,7};
cma = A{:,8};
esg_factor = A{:,9};
market_factor = A{:,10};
time_index = A{:,11};
max_port = max(porflio_number);

out_for_reg_1 = [];
all_coff = [];
all_SE= [];
counter = 0;
for i = 1:length(porflio_number)-1
    
    current_stock = porflio_number(i);
    next_stock =porflio_number(i+1);
    
    if current_stock == max_port
        returns_i = expected_return_stock(i-counter:end); 
        hml_i = hml(i-counter:end);
        smb_i = smb(i-counter:end);
        rmw_i= rmw(i-counter:end);
        cma_i = cma(i-counter:end);
        esg_factor_i = esg_factor(i-counter:end);
        market_factor_i =market_factor(i-counter:end);
        
        %making reg
        factors_w_market_tbl = table(market_factor_i, hml_i, smb_i, rmw_i, cma_i,  esg_factor_i, returns_i);
        reg_total_disp = fitlm(factors_w_market_tbl);
        cofficents_include_a= table2array(reg_total_disp.Coefficients(:,1));
        cofficents_no_a = cofficents_include_a(2:end);
        P_Vals_individual = table2array(reg_total_disp.Coefficients(:,4));
        out_for_reg_1 = [out_for_reg_1 cofficents_no_a];
        all_SE = [all_SE  P_Vals_individual];
        all_coff =[all_coff cofficents_include_a];
        break
    end
    
    if current_stock == next_stock
        
        counter = counter+1;
    else
        if counter >2
        returns_i = expected_return_stock(i-counter:i);
         
        hml_i = hml(i-counter:i);
        smb_i = smb(i-counter:i);
        rmw_i= rmw(i-counter:i);
        cma_i = cma(i-counter:i);
        esg_factor_i = esg_factor(i-counter:i);
        market_factor_i =market_factor(i-counter:i);
        
        %running reg
        factors_w_market_tbl = table(market_factor_i, hml_i, smb_i, rmw_i, cma_i,  esg_factor_i, returns_i);
        reg_total_disp = fitlm(factors_w_market_tbl);
        cofficents_include_a= table2array(reg_total_disp.Coefficients(:,1));
        cofficents_no_a = cofficents_include_a(2:end);
        P_Vals_individual = table2array(reg_total_disp.Coefficients(:,2));
        out_for_reg_1 = [out_for_reg_1 cofficents_no_a];
        all_SE = [all_SE  P_Vals_individual];
        all_coff =[all_coff cofficents_include_a];
        counter = 0;
        end 
    end
end

if output_option==1
   f = out_for_reg_1;
elseif output_option==2
   f = all_coff;
elseif output_option==3
   f = all_SE;
end


end