class Akamai < Formula
  desc "CLI toolkit for working with Akamai's APIs"
  homepage "https://github.com/akamai/cli"
  url "https://github.com/akamai/cli/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "33e4e41ea3697bf84d99354f993edab5ef45a160f92f8e5da094cb12c624980c"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/akamai"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "ee71f9e2ec850cab91c8b748f44a8d95a47355a52344b98d3a1707694ba1c0e2"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", "-tags", "noautoupgrade nofirstrun", *std_go_args, "cli/main.go"
  end

  test do
    assert_match "diagnostics", shell_output("#{bin}/akamai install diagnostics")
    system bin/"akamai", "uninstall", "diagnostics"
  end
end
