

function config = getConfig(index)
	%configs = {};

	config1.ndisc = 0;
	config1.ncont = 7;
	config1.nintr = 0;

  disp(sprintf("Factors = %d\nDiscrete = %d\nContinuous = %d\n", config1.ndisc + config1.ncont, config1.ndisc, config1.ncont));

	config1.ncols = 1 + config1.ndisc + config1.ncont + config1.nintr;
	config1.nrows = pow2((config1.ndisc + config1.ncont));

	config1.intrs = {};%{[1,2], [3,3]}; %,[1,1,2]};

	config1.beta = -3 + 6 * rand(config1.ncols,1); % between U(-3,3)
	config1.lb = ones(config1.ndisc + config1.ncont,1) * -1;
	config1.ub = ones(config1.ndisc + config1.ncont,1);

  disp(sprintf("Beta = \n")); config1.beta
  
  disp(sprintf("LB = \n")); config1.lb
  disp(sprintf("UB = \n")); config1.ub
  
	config1.link = 'logit';

	% MSMA hyperparameters
	config1.popSize = 31;

	config1.maxReset = 4;
	config1.maxIter1 = 5;
	config1.maxIter2 = 2;

  disp(sprintf("\n\nHyper Parameters \npopSize = %d\nmaxReset = %d\nmaxIter1 = %d\nmaxIter2 = %d\n", 
                config1.popSize, config1.maxReset, config1.maxIter1, config1.maxIter2));
                
	config1.mutationProb1 = 0.4;
	config1.mutationProb2 = 0.4;
	config1.elitismRate1  = 0.2;
	config1.elitismRate2  = 0.2;
	config1.survivalRate1 = 1 - config1.elitismRate1;
	config1.survivalRate2 = 1 - config1.elitismRate2;
	config1.stage2SelectionRate = 0.5;
  
  disp(sprintf("mutationProb1 = %.2f\nmutationProb2 = %.2f\n", config1.mutationProb1, config1.mutationProb2));
  disp(sprintf("elitismRate1 = %.2f\nelitismRate2 = %.2f\nsurvivalRate1 = %.2f\nsurvivalRate2 = %.2f\n", 
                    config1.elitismRate1, config1.elitismRate2, config1.survivalRate1, config1.survivalRate2));
  disp(sprintf("stage2SelectionRate = %.2f\n", config1.stage2SelectionRate));
  
  config = config1;
 
	%configs(1,1) = config1;

	% more configs here, one per experiment
	% define the config2, config3, etc here
	% configs(2,1) = config2

	%for i=1:length(configs)
		% common assertions for every configuration
		%config = configs{i,1};
		%assert(length(config.lb) == config.ndisc + config.ncont);
		%assert(length(config.ub) == config.ndisc + config.ncont);
		%assert(length(config.intrs) == config.nintr);
	%end

	%config = configs{index,1};
end
