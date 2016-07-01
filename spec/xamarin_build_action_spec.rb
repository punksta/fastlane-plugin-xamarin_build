describe Fastlane::Actions::XamarinBuildAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The xamarin_build plugin is working!")

      Fastlane::Actions::XamarinBuildAction.run(nil)
    end
  end
end
