tic 

config = getConfig(1);
best = [];

for reset=1:config.maxReset
	% reset the population
	population = createRandomPopulation(config);

	for iter1=1:config.maxIter1
		% stage 1 of MSMA
		population = sortPopulation(population);
		parents = selectParents(population, config, stage=1, sorted=true);
		survivers = selectSurvivers(population, config, stage=1, sorted=true);

		children = breedChildren(parents, config, stage=1);
		mutants = applyMutation(children, config, stage=1);
		population = mergePopulation(survivers, mutants);

		population = sortPopulation(population);
		population2 = promotedPopulation(population, config);
		disp('')
		
		for iter2=1:config.maxIter2
			% stage 2 of MSMA
			parents2 = selectParents(population2, config, stage=2, sorted=true);
			survivers2 = selectSurvivers(population2, config, stage=2, sorted=true);

			children2 = breedChildren(parents2, config, stage=2);
			mutants2 = applyMutation(children2, config, stage=2);
			population2 = mergePopulation(survivers2, mutants2);
			
			disp(sprintf('Run (reset = %d, iter1 = %d, iter2 = %d): fitness => %.2f',
				reset, iter1, iter2, overallFitness(population2)));
			best = getBestDesign(best, population2);
			% displayPopulation(parents2,'parents2');
			% displayPopulation(mutants2,'mutants2');
			% displayPopulation(survivers2,'survivers2');
			% displayPopulation(population2,'pop2');
		end
	end
end

disp(sprintf('\n# Best design fitness => %.2f', best.fitness));
disp(sprintf("X = ")); best.X
disp(sprintf("P = ")); best.p

disp(sprintf("Y = ")); Y = best.X*config.beta

	
	Wp = evalWeights(Y, config.link) .* best.p;
	fisher = best.X' * diag(Wp) * best.X;
  %fitness = 1/det(fisher)
	fitness = log(det(fisher));
  
  disp(sprintf("Fisher = ")); fisher
  disp(sprintf("det(Fisher) = "));
  det(fisher)
  

toc

function config = getConfig(index)
	%configs = {};

	config1.ndisc = 2;
	config1.ncont = 0;
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
	config1.popSize = 30;

	config1.maxReset = 2;
	config1.maxIter1 = 5;
	config1.maxIter2 = 5;

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
