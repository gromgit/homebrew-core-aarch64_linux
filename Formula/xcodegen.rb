class Xcodegen < Formula
  desc "Generate your Xcode project from a spec file and your folder structure"
  homepage "https://github.com/yonaskolb/XcodeGen"
  url "https://github.com/yonaskolb/XcodeGen/archive/2.20.0.tar.gz"
  sha256 "747d833b469bd48f7bd2f286c69efc6ee79a3921446235dc491548acfba5da20"
  license "MIT"
  head "https://github.com/yonaskolb/XcodeGen.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3943c560dbe8bae0c4e75b43920711219e4f1e1c80b8455ea488e8029d9864cb"
    sha256 cellar: :any_skip_relocation, big_sur:       "954d8df6e5e76c59471482dce21df05bed22382e30d1b5cc9bfa6e024508106c"
    sha256 cellar: :any_skip_relocation, catalina:      "72a74170b8b457db6bce90da3daaa6520a24bef3d46d4dfbfd3599bfe45a8b5b"
    sha256 cellar: :any_skip_relocation, mojave:        "1d64fc7e6f3ade59a08eb9b9105c3b1d20d8d9cb4b4de2539590733fd203e014"
  end

  depends_on xcode: ["10.2", :build]
  depends_on macos: :catalina

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/#{name}"
    pkgshare.install "SettingPresets"
  end

  test do
    (testpath/"xcodegen.yml").write <<~EOS
      name: GeneratedProject
      options:
        bundleIdPrefix: com.project
      targets:
        TestProject:
          type: application
          platform: iOS
          sources: TestProject
    EOS
    (testpath/"TestProject").mkpath
    system bin/"XcodeGen", "--spec", testpath/"xcodegen.yml"
    assert_predicate testpath/"GeneratedProject.xcodeproj", :exist?
    assert_predicate testpath/"GeneratedProject.xcodeproj/project.pbxproj", :exist?
    output = (testpath/"GeneratedProject.xcodeproj/project.pbxproj").read
    assert_match "name = TestProject", output
    assert_match "isa = PBXNativeTarget", output
  end
end
