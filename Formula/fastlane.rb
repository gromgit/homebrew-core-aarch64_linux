class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.153.1.tar.gz"
  sha256 "da66a1079891aa889a8876ccef91b758fd9ec2e3a66668b239834c98ddb5b9ff"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git"

  bottle do
    cellar :any
    sha256 "237ae8191966b8e3cbb313da51bc2a5ca21d418a2e20e072e1439ccd1231e568" => :catalina
    sha256 "75a82248e1152036a5fb40b431a87fc08a7df13fe3fd71b9063410cd91d9b651" => :mojave
    sha256 "f18622fe39d9cecfbd37c7078bec355e9183fea0d843b9bacca2ce08070a49c6" => :high_sierra
  end

  depends_on "ruby"

  def install
    ENV["GEM_HOME"] = libexec
    ENV["GEM_PATH"] = libexec

    system "gem", "build", "fastlane.gemspec"
    system "gem", "install", "fastlane-#{version}.gem", "--no-document"

    (bin/"fastlane").write <<~EOS
      #!/bin/bash
      export PATH="#{Formula["ruby"].opt_bin}:#{libexec}/bin:$PATH"
      GEM_HOME="#{libexec}" GEM_PATH="#{libexec}" \\
        exec "#{libexec}/bin/fastlane" "$@"
    EOS
    chmod "+x", bin/"fastlane"
  end

  test do
    assert_match "fastlane #{version}", shell_output("#{bin}/fastlane --version")

    actions_output = shell_output("#{bin}/fastlane actions")
    assert_match "gym", actions_output
    assert_match "pilot", actions_output
    assert_match "screengrab", actions_output
    assert_match "supply", actions_output
  end
end
