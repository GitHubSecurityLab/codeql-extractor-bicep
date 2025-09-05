/**
 * General resource property helpers for Azure resources in Bicep.
 *
 * Provides common property accessors for location, SKU, and tags.
 *
 * Classes:
 * - AzureResource: Abstract base for Azure resources, provides access to location, SKU, and tags.
 * - ResourceProperties: Abstract base for resource property objects.
 * - Sku: Represents the SKU of a resource, with access to name and tier.
 * - Tags: Represents the tags of a resource, with access to tag values by key.
 */

private import bicep

/**
 * Abstract base class for Azure resources in Bicep.
 * Provides accessors for common resource properties such as location, SKU, and tags.
 */
abstract class AzureResource extends Resource {
  /**
   * Gets the location of the resource as a string value.
   *
   * @return The Azure region/location of the resource (e.g., "eastus").
   */
  string resourceLocation() { result = this.getProperty("location").(StringLiteral).getValue() }

  /**
   * Gets the SKU object for the resource.
   *
   * @return The SKU object representing the resource's SKU.
   */
  Sku getSku() { result = this.getProperty("sku") }

  /**
   * Gets the Tags object for the resource.
   *
   * @return The Tags object representing the resource's tags.
   */
  Tags getTags() { result = this.getProperty("tags") }
}

/**
 * Abstract base class for resource property objects.
 * Can be extended to provide additional property accessors for specific resource types.
 */
abstract class ResourceProperties extends Object {
  /**
   * Returns a string representation of the resource properties object.
   */
  override string toString() { result = "ResourceProperties" }
}

/**
 * Represents the SKU of an Azure resource.
 * Provides access to the SKU name and tier.
 */
class Sku extends Object {
  private Resource resource;

  /**
   * Constructs a Sku object for the given resource.
   */
  Sku() { this = resource.getProperty("sku") }

  /**
   * Gets the SKU name as a StringLiteral.
   *
   * @return The SKU name property as a StringLiteral.
   */
  StringLiteral getName() { result = this.getProperty("name") }

  /**
   * Returns the SKU name (e.g., Basic, Standard, Premium).
   *
   * @return The SKU name as a string.
   */
  string name() { result = this.getName().getValue() }

  /**
   * Gets the SKU tier as a StringLiteral.
   *
   * @return The SKU tier property as a StringLiteral.
   */
  StringLiteral getTier() { result = this.getProperty("tier") }

  /**
   * Returns the SKU tier (e.g., Basic, Standard, Premium).
   *
   * @return The SKU tier as a string.
   */
  string tier() { result = this.getTier().getValue() }

  override string toString() { result = "SKU" }
}

/**
 * Represents the tags of an Azure resource.
 * Provides access to tag values by key.
 */
class Tags extends Object {
  private Resource resource;

  /**
   * Constructs a Tags object for the given resource.
   */
  Tags() { this = resource.getProperty("tags") }

  /**
   * Gets the value of a tag by its key.
   *
   * @param key The tag key to look up.
   * @return The value of the tag as a Literals object, or undefined if not present.
   */
  Literals getTag(string key) { result = this.getProperty(key) }

  override string toString() { result = "Tags" }
}
