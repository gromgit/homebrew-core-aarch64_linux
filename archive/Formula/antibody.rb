class Antibody < Formula
  desc "Shell plugin manager"
  homepage "https://getantibody.github.io/"
  url "https://github.com/getantibody/antibody/archive/v6.1.1.tar.gz"
  sha256 "87bced5fba8cf5d587ea803d33dda72e8bcbd4e4c9991a9b40b2de4babbfc24f"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/antibody"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "3c129966f7b16a0be434ef3e5824f2d797128b2f35ede17ec3756b04090d8755"
  end

  deprecate! date: "2022-03-16", because: :repo_archived

  depends_on "go@1.17" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.version=#{version}", "-trimpath", "-o", bin/"antibody"
  end

  test do
    # See if antibody can install a bundle correctly
    system "#{bin}/antibody", "bundle", "rupa/z"
    assert_match("rupa/z", shell_output("#{bin}/antibody list"))
  end
end
