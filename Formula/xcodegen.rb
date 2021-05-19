class Xcodegen < Formula
  desc "Generate your Xcode project from a spec file and your folder structure"
  homepage "https://github.com/yonaskolb/XcodeGen"
  url "https://github.com/yonaskolb/XcodeGen/archive/2.23.0.tar.gz"
  sha256 "4fb8233ee9aff556456d252eb16962e6106cd1fd44f53754b4954e8b91608c0c"
  license "MIT"
  head "https://github.com/yonaskolb/XcodeGen.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1c4d36ce12a201ab03ae505be50a0092412b7a6aa02ac8eefc732bc46b0eddd1"
    sha256 cellar: :any_skip_relocation, big_sur:       "ad1e334484421be20dbb057a2e5421b7ec4343354186f8c4935a244778fc53ba"
    sha256 cellar: :any_skip_relocation, catalina:      "803aec1db1f0201c69451b263492627f584e5b7c913d816c7a210065b536f357"
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
