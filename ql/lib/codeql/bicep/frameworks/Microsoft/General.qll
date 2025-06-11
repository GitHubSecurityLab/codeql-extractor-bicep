private import bicep

class Sku extends Object {
  private Resource resource;

  /**
   * Constructs a Sku object for the given resource.
   */
  Sku() { this = resource.getProperty("sku") }

  /**
   * Returns the SKU name (e.g., Basic, Standard, Premium).
   */
  string getName() {
    result = this.getProperty("name").(StringLiteral).getValue()
  }

  /**
   * Returns the SKU tier (e.g., Basic, Standard, Premium).
   */
  string getTier() {
    result = this.getProperty("tier").(StringLiteral).getValue()
  }

  string toString() {
    result = "SKU"
  }
}
