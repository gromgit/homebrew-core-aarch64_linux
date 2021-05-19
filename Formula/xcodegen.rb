class Xcodegen < Formula
  desc "Generate your Xcode project from a spec file and your folder structure"
  homepage "https://github.com/yonaskolb/XcodeGen"
  url "https://github.com/yonaskolb/XcodeGen/archive/2.23.0.tar.gz"
  sha256 "4fb8233ee9aff556456d252eb16962e6106cd1fd44f53754b4954e8b91608c0c"
  license "MIT"
  head "https://github.com/yonaskolb/XcodeGen.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0040a22bbf29066ee647e158d2b4ed663b591617802db6997655a8546b1c8b25"
    sha256 cellar: :any_skip_relocation, big_sur:       "466378b1a0d67ad4177e79894b31d3011624eddcdd4a4d6ed8b798fd3d01d81e"
    sha256 cellar: :any_skip_relocation, catalina:      "6482c64f28a837227ad59ae97ed92e1658a6ab1931fd7199e88a834f05becdc8"
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
