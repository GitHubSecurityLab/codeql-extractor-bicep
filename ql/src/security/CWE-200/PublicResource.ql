/**
 * @name Internal Resource Public to the Internet
 * @description Internal resources should not be publicly accessible to the Internet.
 * @kind problem
 * @problem.severity error
 * @security-severity 8.0
 * @precision high
 * @id bicep/public-resource
 * @tags security
 *       bicep
 *       azure
 */

import bicep

from PublicResource resource
select resource.getPublicAccessProperty(),
  "Resource '" + resource.getName() + "' is publicly accessible to the Internet."
