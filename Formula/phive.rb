class Phive < Formula
  desc "Phar Installation and Verification Environment (PHIVE)"
  homepage "https://phar.io"
  url "https://github.com/phar-io/phive/releases/download/0.14.5/phive-0.14.5.phar"
  sha256 "70d6de4afb2e4f66ff06e35434299f2a1d81d7ea3fec9c3359adb521c196ff8d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2764cdd6bfa222886599a50fb2d433f4ca09bcc08f2e5a0db3c3898e01c26050"
  end

  depends_on "php"

  def install
    bin.install "phive-#{version}.phar" => "phive"
  end

  test do
    assert_match "No PHARs configured for this project", shell_output("#{bin}/phive status")
  end
end
