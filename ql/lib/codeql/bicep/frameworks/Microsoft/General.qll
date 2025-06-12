private import bicep

abstract class AzureResource extends Resource {
  string resourceLocation() {
    result = this.getProperty("location").(StringLiteral).getValue()
  }

  Sku getSku() { result = this.getProperty("sku") }

  Tags getTags() { result = this.getProperty("tags") }
}

abstract class ResourceProperties extends Object {
  string toString() {
    result = super.toString()
  }
}

class Sku extends Object {
  private Resource resource;

  /**
   * Constructs a Sku object for the given resource.
   */
  Sku() { this = resource.getProperty("sku") }

  /**
   * Returns the SKU name (e.g., Basic, Standard, Premium).
   */
  string getName() { result = this.getProperty("name").(StringLiteral).getValue() }

  /**
   * Returns the SKU tier (e.g., Basic, Standard, Premium).
   */
  string getTier() { result = this.getProperty("tier").(StringLiteral).getValue() }

  string toString() { result = "SKU" }
}

class Tags extends Object {
  private Resource resource;

  /**
   * Constructs a Tags object for the given resource.
   */
  Tags() { this = resource.getProperty("tags") }

  /**
   * Returns the value of a tag by its key.
   */
  Literals getTag(string key) { result = this.getProperty(key) }

  string toString() { result = "Tags" }
}
