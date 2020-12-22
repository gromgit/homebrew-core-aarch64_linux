class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.170.0.tar.gz"
  sha256 "d3b2f592b01e565d6fcb37199ad1efeb97f1879751995d676b0d66c7b78e1a43"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git"

  livecheck do
    url :head
    regex(/^([\d.]+)$/i)
  end

  bottle do
    cellar :any
    sha256 "5ff85b7514eaa315f2724b158900b4167e7405b308dc506508d974868a286f60" => :big_sur
    sha256 "01f5b91eb5cbd8f92b0259f6804fbbfa29876238097da77020d8fb6836b57b5e" => :arm64_big_sur
    sha256 "fb1646105123846fd3791629a55edc3e90b111c2a7c2b0e999e6d3c234f27ade" => :catalina
    sha256 "b9e0be03c7c28d5d11d274ae8c0b20a3d96e5619d9bdb6fca788d312a2365070" => :mojave
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
      export FASTLANE_INSTALLED_VIA_HOMEBREW="true"
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
