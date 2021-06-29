class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.187.0.tar.gz"
  sha256 "142f693fe83db83d78f48ecc86301c55a2eb6e65628290508886326e390da4ae"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "7c4707d4361ca14d9f3308acf736f7e05791c44f1287190fa38109efe35c3fda"
    sha256 cellar: :any, big_sur:       "a770f44ff508f321d2f9d6d6274300a973012dbcc1d3d6bef3d6591c4a80d6c9"
    sha256 cellar: :any, catalina:      "a994a0c09575e21a38709e453db12f831cd96a2a4fb7e4d82fbe3fa6ecf1c321"
    sha256 cellar: :any, mojave:        "37ff0c8c1f9f750a8367120930fb6b31ad5947a0270fbebea77d49ec9045a86e"
  end

  depends_on "ruby@2.7"

  def install
    ENV["GEM_HOME"] = libexec
    ENV["GEM_PATH"] = libexec

    system "gem", "build", "fastlane.gemspec"
    system "gem", "install", "fastlane-#{version}.gem", "--no-document"

    (bin/"fastlane").write_env_script libexec/"bin/fastlane",
      PATH:                            "#{Formula["ruby@2.7"].opt_bin}:#{libexec}/bin:$PATH",
      FASTLANE_INSTALLED_VIA_HOMEBREW: "true",
      GEM_HOME:                        libexec.to_s,
      GEM_PATH:                        libexec.to_s
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
