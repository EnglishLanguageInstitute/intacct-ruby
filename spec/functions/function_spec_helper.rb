def function_base_path(function_name)
  "/function/#{function_name}"
end

def generate_function_xml(function_class, attributes)
  Nokogiri::XML function_class.new(attributes).to_xml
end

def control_id_from(function_xml)
  function_xml.xpath('/function').first.attributes['controlid'].value
end

def function_name_from(function_xml)
  
  child=function_xml.xpath('/function').children.first
  name = child.name
  
  if %w{create update}.include?(name)
    grand_child_name = child.children.first.name
    name = "#{name}/#{grand_child_name}"
  end
  return name
end
