public class MyMain {

    public static void main(String[] args) {

        Student s1 = new Student("KRG10001", "Ravi", 0, 0);
        Student s2 = new Student("KRG10002", "Amit", 0, 1);

        Asset a1 = new Asset("LAB-1", "HDMI Cable", true, 1);
        Asset a2 = new Asset("LAB-2", "Oscilloscope", true, 3);

        Student[] students = { s1, s2 };
        Asset[] assets = { a1, a2 };

        CheckoutService service = new CheckoutService(students, assets);

        CheckoutRequest r1 = new CheckoutRequest("KRG10001", "LAB-1", 2);
        CheckoutRequest r2 = new CheckoutRequest("KRG10002", "LAB-2", 4);

        try {
            System.out.println(service.checkout(r1));
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }

        try {
            System.out.println(service.checkout(r2));
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
}

class Student {
    String uid;
    String name;
    int fine;
    int borrowed;

    Student(String uid, String name, int fine, int borrowed) {
        this.uid = uid;
        this.name = name;
        this.fine = fine;
        this.borrowed = borrowed;
    }

    void check() {
        if (fine > 0)
            throw new IllegalStateException("Fine pending");
        if (borrowed >= 2)
            throw new IllegalStateException("Limit reached");
    }
}

class Asset {
    String id;
    String name;
    boolean available;
    int level;

    Asset(String id, String name, boolean available, int level) {
        this.id = id;
        this.name = name;
        this.available = available;
        this.level = level;
    }

    void check(String uid) {
        if (!available)
            throw new IllegalStateException("Not available");
        if (level == 3 && !uid.startsWith("KRG"))
            throw new SecurityException("Not allowed");
    }
}

class CheckoutRequest {
    String uid;
    String assetId;
    int hours;

    CheckoutRequest(String uid, String assetId, int hours) {
        if (hours < 1 || hours > 6)
            throw new IllegalArgumentException("Invalid hours");
        this.uid = uid;
        this.assetId = assetId;
        this.hours = hours;
    }
}

class CheckoutService {

    Student[] students;
    Asset[] assets;

    CheckoutService(Student[] students, Asset[] assets) {
        this.students = students;
        this.assets = assets;
    }

    Student findStudent(String uid) {
        for (Student s : students)
            if (s.uid.equals(uid))
                return s;
        throw new NullPointerException("Student not found");
    }

    Asset findAsset(String id) {
        for (Asset a : assets)
            if (a.id.equals(id))
                return a;
        throw new NullPointerException("Asset not found");
    }

    String checkout(CheckoutRequest r) {

        Student s = findStudent(r.uid);
        Asset a = findAsset(r.assetId);

        s.check();
        a.check(r.uid);

        if (a.name.contains("Cable") && r.hours > 3) {
            r.hours = 3;
            System.out.println("Cable max 3 hours");
        }

        a.available = false;
        s.borrowed++;

        return "TXN-" + a.id + "-" + s.uid;
    }
}
