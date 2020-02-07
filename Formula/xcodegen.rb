class Xcodegen < Formula
  desc "Generate your Xcode project from a spec file and your folder structure"
  homepage "https://github.com/yonaskolb/XcodeGen"
  url "https://github.com/yonaskolb/XcodeGen/archive/2.13.1.tar.gz"
  sha256 "05bab4f1b60af9d41d0bc12cb555593e3cca9c2635f6a32e7e08b19922867147"
  head "https://github.com/yonaskolb/XcodeGen.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cbefbcd661dc88de5f12cdee9aba5c8beea1a4e51b85f7afcb95f706a424a64f" => :catalina
    sha256 "3f84bb93f2453de4d74777729f0cdd704c00a7c56216a5bb8d28216ccbcbe2ca" => :mojave
  end

  depends_on :xcode => ["10.2", :build]

  def install
    system "make", "install", "PREFIX=#{prefix}"
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
