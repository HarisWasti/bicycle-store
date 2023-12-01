% read table

Address = readtable('Customer Address.csv');
Demographic = readtable('Customer Demographic.csv');
List = readtable("Customer List.csv");
Transactions = readtable('Transactions.csv');


%%
% No.data points
Datapoint_Address = numel(Address);
Datapoint_Demographic = numel(Demographic);
Datapoint_List = numel(List);
Datapoint_Transactions = numel(Transactions);


%%
% Attribute names
Attribute_Name_Address = Address.Properties.VariableNames;
Attribute_Name_Demographic = Demographic.Properties.VariableNames;
Attribute_Name_List = List.Properties.VariableNames;
Attribute_Name_Transactions = Transactions.Properties.VariableNames;


%%
% Attribute types
Attribute_Type_Address = varfun(@class, Address,"OutputFormat","cell");
Attribute_Type_Demographic = varfun(@class, Demographic, "OutputFormat","cell");
Attribute_Type_List = varfun(@class, List, "OutputFormat","cell");
Attribute_Type_Transactions = varfun(@class, Transactions, "OutputFormat","cell");


%%
% Missing values
Missing_Address = sum(ismissing(Address));
Missing_Demographic = sum(ismissing(Demographic));
Missing_List = sum(ismissing(List));
Missing_Transactions = sum(ismissing(Transactions));

% entry errors(no entry errors)


%%
% Create a heatmap for Address table
figure;
imagesc(double(ismissing(Address)));
colormap([1 0 0; 1 1 1]);
colorbar('Ticks', [0.25, 0.75], 'TickLabels', {'Not Missing', 'Missing'});
title('Missing Values Heatmap - Address');

% Create a heatmap for Demographic table
figure;
imagesc(double(ismissing(Demographic)));
colormap([1 0 0; 1 1 1]);
colorbar('Ticks', [0.25, 0.75], 'TickLabels', {'Not Missing', 'Missing'});
title('Missing Values Heatmap - Demographic');

% Create a heatmap for List table
figure;
imagesc(double(ismissing(List)));
colormap([1 0 0; 1 1 1]);
colorbar('Ticks', [0.25, 0.75], 'TickLabels', {'Not Missing', 'Missing'});
title('Missing Values Heatmap - List');

% Create a heatmap for Transactions table
figure;
imagesc(double(ismissing(Transactions)));
colormap([1 0 0; 1 1 1]);
colorbar('Ticks', [0.25, 0.75], 'TickLabels', {'Not Missing', 'Missing'});
title('Missing Values Heatmap - Transactions');

%% Q3g


% Outlier - Address
outliers_Address = isoutlier(Address.property_valuation);
filtered_Address = Address(~outliers_Address, :);


%%


% Outlier - Demographic
variableNames_Demographic = {'past_3_years_bike_related_purchases', 'tenure'};
outliersMatrix_Demographic = false(size(Demographic, 1), numel(variableNames_Demographic));
for i = 1:numel(variableNames_Demographic)
    outliersMatrix_Demographic(:, i) = isoutlier(Demographic.(variableNames_Demographic{i}));
end
anyOutliers_Demographic = any(outliersMatrix_Demographic, 2);
filtered_Demographic = Demographic(~anyOutliers_Demographic, :);



%%


% Outlier - List
variableNames_List = {'past_3_years_bike_related_purchases', 'tenure', 'property_valuation', 'Var17', 'Var18', 'Var19', 'Var20', 'Var21', 'Rank', 'Value'};
outliersMatrix_List = false(size(List, 1), numel(variableNames_List));
for i = 1:numel(variableNames_List)
    outliersMatrix_List(:, i) = isoutlier(List.(variableNames_List{i}));
end
anyOutliers_List = any(outliersMatrix_List, 2);
filtered_List = List(~anyOutliers_List, :);



%%
% outlier - transactions
variableNames_Transactions = {'list_price', 'standard_cost'};
outliersMatrix_Transactions = false(size(Transactions, 1), numel(variableNames_Transactions));

for i = 1:numel(variableNames_Transactions)
    if iscell(Transactions.(variableNames_Transactions{i}))
        Transactions.(variableNames_Transactions{i}) = str2double(strrep(Transactions.(variableNames_Transactions{i}), '$', ''));
    end
    
    outliersMatrix_Transactions(:, i) = isoutlier(Transactions.(variableNames_Transactions{i}));
end
anyOutliers_Transactions = any(outliersMatrix_Transactions, 2);
filtered_Transactions = Transactions(~anyOutliers_Transactions, :);



%% Q3b
% Fill Missing(Address has no missing values)

% Fill Missing - Demographic - Numeric - tenure
dataColumn_Demographic = filtered_Demographic.tenure;
medianValue_Demographic = median(dataColumn_Demographic, 'omitnan');
filledDataColumn_Demographic = fillmissing(dataColumn_Demographic, 'constant', medianValue_Demographic);
filtered_Demographic.tenure = filledDataColumn_Demographic;

% Categorical - DOB
Categorical_Demographic1 = mode(categorical(filtered_Demographic.DOB));
Categorical_Demographic1 = datetime(char(Categorical_Demographic1), 'InputFormat', 'dd-MMM-yyyy');
filtered_Demographic.DOB = fillmissing(filtered_Demographic.DOB, 'constant', Categorical_Demographic1);

% Categorical - job_title
Categorical_Demographic2 = mode(categorical(filtered_Demographic.job_title));
Categorical_Demographic2_char = char(Categorical_Demographic2);
filtered_Demographic.job_title = fillmissing(filtered_Demographic.job_title, 'constant', Categorical_Demographic2_char);

% Categorical - last_name
Categorical_Demographic3 = mode(categorical(filtered_Demographic.last_name));
Categorical_Demographic3_char = char(Categorical_Demographic3);
filtered_Demographic.last_name = fillmissing(filtered_Demographic.last_name, 'constant', Categorical_Demographic3_char);
%%
% Fill Missing - last_name - List
Categorical_List1 = mode(categorical(filtered_Demographic.last_name));
Categorical_List1_char = char(Categorical_List1);
filtered_List.last_name = fillmissing(filtered_List.last_name, 'constant', Categorical_List1_char);

% first change DOB to datetime type as it was listed as cell
date_List = filtered_List.DOB;
dateTimes_List = datetime(date_List, 'InputFormat', 'dd-MM-yyyy');
filtered_List.DOB = dateTimes_List;

% Categorical - DOB - List
Categorical_List2 = mode(categorical(filtered_List.DOB));
Categorical_List2 = datetime(char(Categorical_List2), 'InputFormat', 'dd-MMM-yyyy');
filtered_List.DOB = fillmissing(filtered_List.DOB, 'constant', Categorical_List2);

% Categorical - job_title - List
Categorical_List3 = mode(categorical(filtered_List.job_title));
Categorical_List3_char = char(Categorical_List3);
filtered_List.job_title = fillmissing(filtered_List.job_title, 'constant', Categorical_List3_char);
%%
% Fill Missing - online_order - Transactions
Categorical_Transaction1 = mode(categorical(filtered_Transactions.online_order));
Categorical_Transaction1_char = char(Categorical_Transaction1);
filtered_Transactions.online_order = fillmissing(filtered_Transactions.online_order, 'constant', Categorical_Transaction1_char);

% Categorical - brand - Transactions
Categorical_Transaction2 = mode(categorical(filtered_Transactions.brand));
Categorical_Transaction2_char = char(Categorical_Transaction2);
filtered_Transactions.brand = fillmissing(filtered_Transactions.brand, 'constant', Categorical_Transaction2_char);

% Categorical - product_line - Transactions
Categorical_Transaction3 = mode(categorical(filtered_Transactions.product_line));
Categorical_Transaction3_char = char(Categorical_Transaction3);
filtered_Transactions.product_line = fillmissing(filtered_Transactions.product_line, 'constant', Categorical_Transaction3_char);

% Categorical - product_class - Transactions
Categorical_Transaction4 = mode(categorical(filtered_Transactions.product_class));
Categorical_Transaction4_char = char(Categorical_Transaction4);
filtered_Transactions.product_class = fillmissing(filtered_Transactions.product_class, 'constant', Categorical_Transaction4_char);

% Categorical - product_size - Transactions 
Categorical_Transaction5 = mode(categorical(filtered_Transactions.product_size));
Categorical_Transaction5_char = char(Categorical_Transaction5);
filtered_Transactions.product_size = fillmissing(filtered_Transactions.product_size, 'constant', Categorical_Transaction5_char);

% Numeric - standard_cost - Transactions
dataColumn_Transaction = filtered_Transactions.standard_cost;
medianValue_Transaction = median(dataColumn_Transaction, 'omitnan');
filledDataColumn_Transaction = fillmissing(dataColumn_Transaction, 'constant', medianValue_Transaction);
filtered_Transactions.standard_cost = filledDataColumn_Transaction;

% Numeric - product_first_sold_date - Transactions
dataColumn_Transaction2 = filtered_Transactions.product_first_sold_date;
medianValue_Transaction2 = median(dataColumn_Transaction2, 'omitnan');
filledDataColumn_Transaction2 = fillmissing(dataColumn_Transaction2, 'constant', medianValue_Transaction2);
filtered_Transactions.product_first_sold_date = filledDataColumn_Transaction2;
%% Q3c
% removing columns - Demographic
columnsToRemove_Demographic = {'deceased_indicator', 'default'};
filtered_Demographic = removevars(filtered_Demographic, columnsToRemove_Demographic);

% removing columns - List
columnsToRemove_List = {'deceased_indicator', 'Var17', 'Var18', 'Var19', 'Var20', 'Var21'};
filtered_List = removevars(filtered_List, columnsToRemove_List);
%%
% age column for demographic

% Calculate age based on date of birth
currentDate = datetime('13-Nov-2023', 'Format', 'dd-MMM-yyyy'); % Assuming the current date is 13/11/2023
dateOfBirth = filtered_Demographic.DOB;
age = years(currentDate - dateOfBirth);

% Add the Age column to the filtered_Demographic table
roundedAge = ceil(age);
filtered_Demographic.Age = roundedAge;

% Move the 'Age' column next to 'DOB'
dobIndex = find(strcmp(filtered_Demographic.Properties.VariableNames, 'DOB'));
ageIndex = find(strcmp(filtered_Demographic.Properties.VariableNames, 'Age'));
filtered_Demographic = movevars(filtered_Demographic, 'Age', 'After', 'DOB');

% Identify the rows to remove (where age is more than 110)
ageThreshold = 110;
rowsToRemove_age = filtered_Demographic.Age > ageThreshold;

% Remove the identified rows
filtered_Demographic(rowsToRemove_age, :) = [];
%%
% add age column for list

% Calculate age based on date of birth
currentDate2 = datetime('13-Nov-2023', 'Format', 'dd-MMM-yyyy'); % Assuming the current date is 13/11/2023
dateOfBirth2 = filtered_List.DOB;
age2 = years(currentDate2 - dateOfBirth2);

% Add the Age column to the filtered_Demographic table
roundedAge2 = ceil(age2);
filtered_List.Age = roundedAge2;

% Move the 'Age' column next to 'DOB'
dobIndex2 = find(strcmp(filtered_List.Properties.VariableNames, 'DOB'));
ageIndex2 = find(strcmp(filtered_List.Properties.VariableNames, 'Age'));
filtered_List = movevars(filtered_List, 'Age', 'After', 'DOB');

% Identify the rows to remove (where age is more than 110)
ageThreshold2 = 110;
rowsToRemove_age2 = filtered_List.Age > ageThreshold2;

% Remove the identified rows
filtered_List(rowsToRemove_age2, :) = [];

%%
% Q3

% Merge tables - Demograpic and Transactions
demographic_Transactions = innerjoin(filtered_Demographic, filtered_Transactions, 'Keys', 'customer_id');

%%
% Q3d

% Add 'revenue' column to Demographic_mod
Demographic_mod.revenue = splitapply(@sum, demographic_Transactions.list_price, findgroups(demographic_Transactions.customer_id));

% Add 'avg_spent' column to Demographic_mod
Demographic_mod.avg_spent = splitapply(@mean, demographic_Transactions.list_price, findgroups(demographic_Transactions.customer_id));

% Display histogram for avg spent per customer
figure;
histogram(Demographic_mod.avg_spent);
title('Avg amount spent per customer');
xlabel('Average Spent')
ylabel('Frequency')
%%
% Q3d

% Display histogram for total spent per customer
figure;
histogram(Demographic_mod.revenue);
title('Total Sales per Customer');
xlabel('customer id');
ylabel('Frequency');


%%
% Update values in the 'brand' column
demographic_Transactions.brand(ismember(demographic_Transactions.brand, "OHM Cycles")) = {'OHM'};
demographic_Transactions.brand(ismember(demographic_Transactions.brand, "Norco Bicycles")) = {'Norco'};
demographic_Transactions.brand(ismember(demographic_Transactions.brand, "Giant Bicycles")) = {'Giant'};
demographic_Transactions.brand(ismember(demographic_Transactions.brand, "Trek Bicycles")) = {'Trek'};




%%
% make composite key for List

% Convert numeric Age to cell array of strings
filtered_List.Age = cellstr(num2str(filtered_List.Age));
%%
% Concatenate columns horizontally and add as a new column
filtered_List.List_id = strcat(filtered_List.first_name, ' ', filtered_List.Age);

filtered_List = movevars(filtered_List, 'List_id', 'Before', 'first_name');
%%
% Age back to numeric
filtered_List.Age = str2double(filtered_List.Age);
%%
%make a new table for product_id

% Get unique product_id values
uniqueProductIDs = unique(filtered_Transactions.product_id);

% Initialize a new table 'product'
product = table();

% Loop through unique product_id values
for i = 1:length(uniqueProductIDs)
    % Select rows for the current product_id
    rowsForProduct = filtered_Transactions(filtered_Transactions.product_id == uniqueProductIDs(i), :);

    % Select only the necessary columns for the 'product' table
    newRow = rowsForProduct(1, {'product_id', 'brand', 'product_line', 'product_size', 'list_price', 'standard_cost', 'product_first_sold_date'});
    
    % Add the selected row to the 'product' table
    product = [product; newRow];
end

%%
% metadata - Address
Datapoint_filtered_Address = numel(filtered_Address);
Attribute_Type_filtered_Address = varfun(@class, filtered_Address,"OutputFormat","cell");
num_address = varfun(@isnumeric, filtered_Address, 'OutputFormat', 'uniform');
numeric_address = filtered_Address(:, num_address);
standard_deviation = std(numeric_address);
mean_address = mean(numeric_address);
median_address = median(numeric_address);

% Create separate tables for each statistic
table_Datapoint = table(Datapoint_filtered_Address, 'VariableNames', {'Datapoint'});
table_Attribute_Type = table(Attribute_Type_filtered_Address, 'VariableNames', {'Attribute_Type'});
table_StdDev = table(standard_deviation, 'VariableNames', {'Standard_Deviation'});
table_Mean = table(mean_address, 'VariableNames', {'Mean'});
table_Median = table(median_address, 'VariableNames', {'Median'});

% Concatenate tables horizontally
metadata_address = [table_Datapoint, table_Attribute_Type, table_StdDev, table_Mean, table_Median];

% split nested tables
flat_combined_table = splitvars(metadata_address);

writetable(flat_combined_table, 'metadata_Address.csv', 'Delimiter', ',');

%%
% metadata - Demographic_Transactions
Datapoint_demographic_Transactions = numel(demographic_Transactions);
Attribute_Type_demographic_Transactions = varfun(@class, demographic_Transactions,"OutputFormat","cell");
num_demographic_Transactions = varfun(@isnumeric, demographic_Transactions, 'OutputFormat', 'uniform');
numeric_prod = demographic_Transactions(:, num_demographic_Transactions);
standard_deviation2 = std(numeric_prod);
mean_demtrans = mean(numeric_prod);
median_demtrans = median(numeric_prod);


% Create separate tables for each statistic
table_Datapoint2 = table(Datapoint_demographic_Transactions, 'VariableNames', {'Datapoint'});
table_Attribute_Type2 = table(Attribute_Type_demographic_Transactions, 'VariableNames', {'Attribute_Type'});
table_StdDev2 = table(standard_deviation2, 'VariableNames', {'Standard_Deviation'});
table_Mean2 = table(mean_demtrans, 'VariableNames', {'Mean'});
table_Median2 = table(median_demtrans, 'VariableNames', {'Median'});

% Concatenate tables horizontally
metadata_demographic_Transactions = [table_Datapoint2, table_Attribute_Type2, table_StdDev2, table_Mean2, table_Median2];

% split nested tables
flat_combined_table2 = splitvars(metadata_demographic_Transactions);

writetable(flat_combined_table2, 'metadata_demographic_Transactions.csv', 'Delimiter', ',');

%%
% metadata - Transaction
Datapoint_filtered_transactions = numel(filtered_Transactions);
Attribute_Type_filtered_Transactions = varfun(@class, filtered_Transactions,"OutputFormat","cell");
num_trans = varfun(@isnumeric, filtered_Transactions, 'OutputFormat', 'uniform');
numeric_trans = filtered_Transactions(:, num_trans);
standard_deviation4 = std(numeric_trans);
mean_trans = mean(numeric_trans);
median_trans = median(numeric_trans);

% Create separate tables for each statistic
table_Datapoint4 = table(Datapoint_filtered_transactions, 'VariableNames', {'Datapoint'});
table_Attribute_Type4 = table(Attribute_Type_filtered_Transactions, 'VariableNames', {'Attribute_Type'});
table_StdDev4 = table(standard_deviation4, 'VariableNames', {'Standard_Deviation'});
table_Mean4 = table(mean_trans, 'VariableNames', {'Mean'});
table_Median4 = table(median_trans, 'VariableNames', {'Median'});

% Concatenate tables horizontally
metadata_trans = [table_Datapoint4, table_Attribute_Type4, table_StdDev4, table_Mean4, table_Median4];

% split nested tables
flat_combined_table4 = splitvars(metadata_trans);

writetable(flat_combined_table4, 'metadata_Trans.csv', 'Delimiter', ',');

%%
% metadata - List
Datapoint_filtered_List = numel(filtered_List);
Attribute_Type_filtered_List = varfun(@class, filtered_List,"OutputFormat","cell");
num_list = varfun(@isnumeric, filtered_List, 'OutputFormat', 'uniform');
numeric_list = filtered_List(:, num_list);
standard_deviation3 = std(numeric_list);
mean_list = mean(numeric_list);
median_list = median(numeric_list);

% Create separate tables for each statistic
table_Datapoint3 = table(Datapoint_filtered_List, 'VariableNames', {'Datapoint'});
table_Attribute_Type3 = table(Attribute_Type_filtered_List, 'VariableNames', {'Attribute_Type'});
table_StdDev3 = table(standard_deviation3, 'VariableNames', {'Standard_Deviation'});
table_Mean3 = table(mean_list, 'VariableNames', {'Mean'});
table_Median3 = table(median_list, 'VariableNames', {'Median'});

% Concatenate tables horizontally
metadata_List = [table_Datapoint3, table_Attribute_Type3, table_StdDev3, table_Mean3, table_Median3];

% split nested tables
flat_combined_table3 = splitvars(metadata_List);

writetable(flat_combined_table3, 'metadata_List.csv', 'Delimiter', ',');
%%
% metadata - product
Datapoint_product = numel(product);
Attribute_Type_product = varfun(@class, product,"OutputFormat","cell");
num_prod = varfun(@isnumeric, product, 'OutputFormat', 'uniform');
numeric_list = product(:, num_prod);
standard_deviation4 = std(numeric_list);
mean_prod = mean(numeric_list);
median_prod = median(numeric_list);

% Create separate tables for each statistic
table_Datapoint5 = table(Datapoint_product, 'VariableNames', {'Datapoint'});
table_Attribute_Type5 = table(Attribute_Type_product, 'VariableNames', {'Attribute_Type'});
table_StdDev5 = table(standard_deviation4, 'VariableNames', {'Standard_Deviation'});
table_Mean5 = table(mean_prod, 'VariableNames', {'Mean'});
table_Median5 = table(median_prod, 'VariableNames', {'Median'});

% Concatenate tables horizontally
metadata_product = [table_Datapoint5, table_Attribute_Type5, table_StdDev5, table_Mean5, table_Median5];

% split nested tables
flat_combined_table5 = splitvars(metadata_product);

writetable(flat_combined_table5, 'metadata_product.csv', 'Delimiter', ',');




%%
writetable(filtered_Address, 'cleaned_Address.csv');
writetable(demographic_Transactions, 'cleaned_demographic_Transactions.csv');
writetable(filtered_Transactions, 'cleaned_Trans.csv');
writetable(product, 'cleaned_prod.csv');
writetable(filtered_List, 'cleaned_List.csv');










