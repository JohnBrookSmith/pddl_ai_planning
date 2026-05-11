package fr.uga.pddl4j.planners.statespace.search;

import fr.uga.pddl4j.parser.Parser;
import fr.uga.pddl4j.problem.ParsedProblem;
import fr.uga.pddl4j.problem.Problem;
import fr.uga.pddl4j.problem.Grounder;
import fr.uga.pddl4j.plan.Plan;

public class RunAStar {

    public static void main(String[] args) throws Exception {

        if (args.length != 2) {
            System.err.println("Usage: RunAStar <domain.pddl> <problem.pddl>");
            System.exit(1);
        }

        // Step 1: Parse domain + problem
        Parser parser = new Parser();
        parser.parse(args[0], args[1]);
        ParsedProblem parsed = parser.getProblem();

        // Step 2: Ground the problem (this produces the real Problem object)
        Problem problem = Grounder.getInstance().ground(parsed);

        // Step 3: Create A* search engine
        AStar astar = new AStar();

        // Step 4: Run search
        Plan plan = astar.search(problem);

        if (plan != null) {
            System.out.println("Plan found:");
            System.out.println(plan);
        } else {
            System.out.println("No plan found.");
        }
    }
}