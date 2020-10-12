class Act < Formula
  desc "Run your GitHub Actions locally 🚀"
  homepage "https://github.com/nektos/act"
  url "https://github.com/nektos/act/archive/v0.2.16.tar.gz"
  sha256 "e67812743a37cc50bbf80403eea9ac957b5a4a056b4f28b21e1aaabdd270ca22"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "23704fe672478e6ff666099184ade714dcaca4506f1e23558d47597151e7f290" => :catalina
    sha256 "5c7891349dd286524eda4a59bf5502c1b26d40741b9e1623a055994dc0326cf9" => :mojave
    sha256 "85860acc4ec3aa9dfcb4ad8b5eab0f7dce36809e89ca77b1a9e360187518a5a3" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "dist/local/act"
  end

  test do
    system "git", "clone", "https://github.com/stefanzweifel/laravel-github-actions-demo.git"
    cd "laravel-github-actions-demo" do
      system "git", "checkout", "v2.0"

      pull_request_jobs = shell_output("#{bin}/act pull_request --list")
      assert_match "php-cs-fixer", pull_request_jobs

      push_jobs = shell_output("#{bin}/act push --list")
      assert_match "phpinsights", push_jobs
      assert_match "phpunit", push_jobs
    end
  end
end
