class Act < Formula
  desc "Run your GitHub Actions locally 🚀"
  homepage "https://github.com/nektos/act"
  url "https://github.com/nektos/act/archive/v0.2.29.tar.gz"
  sha256 "92c7f774395e98cff2e53c9739d8266027837cd27f437514ea342a59179c3115"
  license "MIT"
  head "https://github.com/nektos/act.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93df973291a43931e5daf45c3af27d53041ab083825f37f8ff843a527b03789b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0c0956174f1bd2ea40c05026b794e9a69b3cc31a46d42fd2128e30216c6427fe"
    sha256 cellar: :any_skip_relocation, monterey:       "5215af5563695f5d0c11f4762c309c3bdf8a80ed3798e7a15ae49665d63c864c"
    sha256 cellar: :any_skip_relocation, big_sur:        "68e14ba5fb0453147f9fe090d8daee4af8d3bf7f5c3c02a0c917a3b4f715f711"
    sha256 cellar: :any_skip_relocation, catalina:       "368b9522f56066dc5737970e1e698304d0040aa4c5575cf1510c690a8f954571"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fa51c27af6b9618ba9614210141fd4897b27d8175c533bb406da7a9f29bb1d9"
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
