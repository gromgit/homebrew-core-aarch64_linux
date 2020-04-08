class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v4.1.1.tar.gz"
  sha256 "dd50e5e68813990dcaba23564a0481f09550e3e80402ac0e4689685b7b8c46a4"

  bottle do
    cellar :any_skip_relocation
    sha256 "088c736cb7f5ebbe568d3ceedd99449dbe746359ca0b541f5ffa6ce557b00f81" => :catalina
    sha256 "a36a6acf16e46b2ce76f4dba192906407bad37b3efd0477e4ee472b3b5991800" => :mojave
    sha256 "7d9f0a346f85d9ee87c74d12b98265a5d294e9b41d2e08a01c6ec4a2997c95b7" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-X github.com/zricethezav/gitleaks/version.Version=#{version}",
                 *std_go_args
  end

  test do
    assert_match "remote repository is empty",
      shell_output("#{bin}/gitleaks -r https://github.com/gitleakstest/emptyrepo.git", 2)
  end
end
