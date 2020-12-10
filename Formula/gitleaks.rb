class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v7.1.2.tar.gz"
  sha256 "8f1db3bb9cb6df17eb6c9d2c1bda4cd57601f664ca8cabc7bf7aa93da24ca906"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "caf3ad85c3fdeb40e3102a0a85bf0a20647b772eef02acd8ed1a98d6ebe8261d" => :big_sur
    sha256 "ffb1b048f63cea340157c1c3d96ab24a2bf7c84a2b4b0eec32deac8262de8886" => :catalina
    sha256 "66c934a0ecb6ba9f101fd753741ac78da4b7e4e38c4757711c014a828322395a" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-X github.com/zricethezav/gitleaks/v#{version.major}/version.Version=#{version}",
                 *std_go_args
  end

  test do
    output = shell_output("#{bin}/gitleaks -r https://github.com/gitleakstest/emptyrepo.git 2>&1", 1)
    assert_match "level=info msg=\"cloning... https://github.com/gitleakstest/emptyrepo.git\"", output
    assert_match "level=error msg=\"remote repository is empty\"", output

    assert_equal version, shell_output("#{bin}/gitleaks --version")
  end
end
