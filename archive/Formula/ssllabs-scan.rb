class SsllabsScan < Formula
  desc "This tool is a command-line client for the SSL Labs APIs"
  homepage "https://github.com/ssllabs/ssllabs-scan/"
  url "https://github.com/ssllabs/ssllabs-scan/archive/v1.5.0.tar.gz"
  sha256 "51c52e958d5da739910e9271a3abf4902892b91acb840ea74f5c052a71e3a008"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/ssllabs-scan"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "dae55cb30e072701d285d1b459a09fd7fe48e273b7e8f238ef9831af634ddfda"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w", "ssllabs-scan-v3.go"
  end

  def caveats
    <<~EOS
      By installing this package you agree to the Terms and Conditions defined by Qualys.
      You can find the terms and conditions at this link:
         https://www.ssllabs.com/about/terms.html

      If you do not agree with those you should uninstall the formula.
    EOS
  end

  test do
    system "#{bin}/ssllabs-scan", "-grade", "-quiet", "-usecache", "ssllabs.com"
  end
end
