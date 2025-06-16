export function toCamelCaseDeep(obj: any): any {
  if (Array.isArray(obj)) {
    return obj.map(toCamelCaseDeep);
  } else if (obj !== null && typeof obj === 'object') {
    return Object.keys(obj).reduce((acc, key) => {
      // Handle special case for custom_ingredient_id
      if (key === 'custom_ingredient_id') {
        acc['customIngredient'] = { id: obj[key] };
        return acc;
      }
      // Handle special case for unit_id
      if (key === 'unit_id') {
        acc['unit'] = obj[key] !== null ? { id: obj[key] } : null;
        return acc;
      }
      const camelKey = key.replace(/_([a-z])/g, (_, letter) => letter.toUpperCase());
      acc[camelKey] = toCamelCaseDeep(obj[key]);
      return acc;
    }, {} as Record<string, any>);
  }
  return obj;
} 