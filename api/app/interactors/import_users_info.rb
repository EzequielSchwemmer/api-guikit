class ImportUsersInfo
  include Interactor::Organizer

  organize FindUsers,
           ImportSegments,
           ImportUserSegments

  before do
    context.fail!(error: 'Is expected a JSON file') unless json_file?
    context.json = JSON.parse(File.read(context.file.tempfile))
  end

  private

  def json_file?
    context.file.content_type == 'application/json'
  end
end
