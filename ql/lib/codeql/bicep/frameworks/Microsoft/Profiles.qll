private import bicep
private import codeql.bicep.frameworks.Microsoft.General

module Profiles {
   
    /**
     * Represents the Windows profile for a managed AKS cluster.
     */
    class WindowsProfile extends Object {
        private Object properties;
  
        /**
         * Constructs a WindowsProfile object for the given properties.
         */
        WindowsProfile() { this = properties.getProperty("windowsProfile") }
  
        /**
         * Gets the admin username property.
         */
        StringLiteral getAdminUsername() { result = this.getProperty("adminUsername") }
  
        /**
         * Gets the admin password property.
         */
        StringLiteral getAdminPassword() { result = this.getProperty("adminPassword") }
  
        /**
         * Gets the license type property.
         */
        StringLiteral getLicenseType() { result = this.getProperty("licenseType") }
  
        /**
         * Gets the GMSAProfile property.
         */
        Expr getGmsaProfile() { result = this.getProperty("gmsaProfile") }
  
        /**
         * Gets whether enabling CSI proxy is enabled.
         */
        Boolean getEnablingCSIProxy() { result = this.getProperty("enablingCSIProxy") }
  
        string toString() { result = "WindowsProfile" }
      }
  
      /**
       * Represents the Linux profile for a managed AKS cluster.
       */
      class LinuxProfile extends Object {
        private Object properties;
  
        /**
         * Constructs a LinuxProfile object for the given properties.
         */
        LinuxProfile() { this = properties.getProperty("linuxProfile") }
  
        /**
         * Gets the admin username property.
         */
        StringLiteral getAdminUsername() { result = this.getProperty("adminUsername") }
  
        /**
         * Gets the SSH key property.
         */
        Expr getSsh() { result = this.getProperty("ssh") }
  
        string toString() { result = "LinuxProfile" }
      }
   
}