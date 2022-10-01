class Act < Formula
  desc "Run your GitHub Actions locally 🚀"
  homepage "https://github.com/nektos/act"
  url "https://github.com/nektos/act/archive/v0.2.32.tar.gz"
  sha256 "1d97468200aeae51cef70bc0b7c7497854d7fb512720768e2aba8d9661a28fc7"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cde1029572ec10ebe7984e71a0cd05e3417d8e9eb123f4c31e663a31cc586a98"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "35b0d8a299ae5f6480a2f7e0896eba5dda4752066ce8e6e7f9fb9e5a36d22272"
    sha256 cellar: :any_skip_relocation, monterey:       "0ceab6d605042493053dec22ab0eca8213823be6eaba3fa0008cce3f85dd59fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "2fc6c8be3e166b409073fa46e3e86a7fd924dc52dbd31025c5caeeca75d17624"
    sha256 cellar: :any_skip_relocation, catalina:       "a9b49718b2d72cf7a6d44976b1dd2c830795cf72675ba9d39a86b8cba7824e76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8044915c9a942f1fe7da391a81e2af0dff0c1ac388094931d0b4ac34fd94f97c"
  end

  depends_on "go" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "dist/local/act"
  end

  test do
    (testpath/".actrc").write <<~EOS
      -P ubuntu-latest=node:12.6-buster-slim
      -P ubuntu-12.04=node:12.6-buster-slim
      -P ubuntu-18.04=node:12.6-buster-slim
      -P ubuntu-16.04=node:12.6-stretch-slim
    EOS

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
