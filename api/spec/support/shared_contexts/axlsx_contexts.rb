shared_context 'with axlsx' do
  # all xlsx specs describe must be normalized
  # "folder/view_name.xlsx.axlsx"
  # allow to infer the template path
  let(:template_name) { description }
  let(:render_locals) { {} }
  let(:package) { Axlsx::Package.new }
  let(:wb) { package.workbook }
  let(:axlsx_binding) { Kernel.binding }
  let(:axlsx_sources) { File.read(Rails.root.join(*template_path)) }
  let(:axlsx_struct) { Struct.new(:source).new(axlsx_sources) }
  let(:axlsx_builder) { ActionView::Template::Handlers::AxlsxBuilder.call(axlsx_struct) }
  let(:xls_content_type) { 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' }
  let(:template_path) do
    ['app', 'views', template_name]
  end

  # This helper will be used in tests
  let(:render_template) do
    render_locals.each do |key, value|
      axlsx_binding.local_variable_set key, value
    end
    axlsx_binding.local_variable_set(:wb, wb)
    axlsx_binding.local_variable_set(:sheet, wb.add_worksheet)

    # mimics an ActionView::Template class, presenting a 'source' method
    # to retrieve the content of the template
    axlsx_binding.eval(axlsx_builder)
    axlsx_binding.local_variable_get(:wb)
  end
end
