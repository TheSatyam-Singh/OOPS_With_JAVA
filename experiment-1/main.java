import java.util.*;

interface ProctoringStep {
    void run();
}

interface IdentityCheck {
    void check();
}

class AIIdentityCheck implements IdentityCheck {
    public void check() {
        System.out.println("AI is verifying identity");
    }
}

class HumanIdentityCheck implements IdentityCheck {
    public void check() {
        System.out.println("Human is verifying identity");
    }
}

interface EnvironmentCheck {
    void check();
}

class AIEnvironmentCheck implements EnvironmentCheck {
    public void check() {
        System.out.println("AI is checking environment");
    }
}

interface BehaviourCheck {
    void check();
}

class AIBehaviourCheck implements BehaviourCheck {
    public void check() {
        System.out.println("AI is monitoring behaviour");
    }
}

class HumanBehaviourCheck implements BehaviourCheck {
    public void check() {
        System.out.println("Human is monitoring behaviour");
    }
}

class IdentityStep implements ProctoringStep {
    IdentityCheck identity;

    IdentityStep(IdentityCheck identity) {
        this.identity = identity;
    }

    public void run() {
        identity.check();
    }
}

class EnvironmentStep implements ProctoringStep {
    EnvironmentCheck environment;

    EnvironmentStep(EnvironmentCheck environment) {
        this.environment = environment;
    }

    public void run() {
        environment.check();
    }
}

class BehaviourStep implements ProctoringStep {
    BehaviourCheck behaviour;

    BehaviourStep(BehaviourCheck behaviour) {
        this.behaviour = behaviour;
    }

    public void run() {
        behaviour.check();
    }
}

class ProctoringController {
    List<ProctoringStep> steps = new ArrayList<>();

    void addStep(ProctoringStep step) {
        steps.add(step);
    }

    void startExam() {
        for (ProctoringStep step : steps) {
            step.run();
        }
    }
}

public class Main {
    public static void main(String[] args) {

        ProctoringController controller = new ProctoringController();

        controller.addStep(new IdentityStep(new AIIdentityCheck()));
        controller.addStep(new EnvironmentStep(new AIEnvironmentCheck()));
        controller.addStep(new BehaviourStep(new HumanBehaviourCheck()));

        controller.startExam();
    }
}
