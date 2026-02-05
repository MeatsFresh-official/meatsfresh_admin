---
description: How to run the MeatsFresh application using Tomcat
---

### Option 1: Run with Embedded Tomcat (Recommended for Development)
This project is a Spring Boot application. You can run it directly using the embedded Tomcat server.

1.  Open a terminal in the project root: `c:\Users\priya\IdeaProjects\meatsfresh\deliveryAdmin\deliveryAdmin`
2.  Run the following command:
    ```bash
    .\mvnw.cmd spring-boot:run
    ```
3.  The application will be available at: [http://localhost:8086/deliveryAdmin/login](http://localhost:8086/deliveryAdmin/login)

### Option 2: Deploy to Standalone Tomcat
If you want to run the application on a standalone Tomcat instance (e.g., Tomcat 10+):

1.  **Build the WAR file**:
    ```bash
    .\mvnw.cmd clean package -DskipTests
    ```
2.  **Locate the WAR**: The file is generated at `target/deliveryAdmin-0.0.1-SNAPSHOT.war`.
3.  **Deploy**: Copy this `.war` file to your Tomcat's `webapps` folder.
    *   *Note*: If you rename it to `deliveryAdmin.war`, the context path will be `/deliveryAdmin`.
4.  **Start Tomcat**: Run `bin/startup.bat` from your Tomcat installation directory.

### Option 3: Using IntelliJ Smart Tomcat Plugin
The codebase contains a `.smarttomcat` configuration. To use it:
1.  Ensure the **Smart Tomcat** plugin is installed in IntelliJ.
2.  Create a new **Smart Tomcat** Run Configuration.
3.  Set the **Deployment Directory** to `c:\Users\priya\IdeaProjects\meatsfresh\deliveryAdmin\deliveryAdmin\src\main\webapp`.
4.  Set the **Context Path** to `/deliveryAdmin`.
5.  Set the **Server Port** to `8086`.
