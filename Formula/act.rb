class Act < Formula
  desc "Run your GitHub Actions locally 🚀"
  homepage "https://github.com/nektos/act"
  url "https://github.com/nektos/act/archive/v0.2.19.tar.gz"
  sha256 "6058f4c2b6a6bffa1cf4a37b65e94216eec56d4766927a2610faa0e177309452"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "129324772b70bddbac8bf5f05ad2c446a898287089d07c7590b0812efc66cf95" => :big_sur
    sha256 "00d1cd0957e9bc4c316d331891cb490657f1203fda35f9d2ea7033edcb830065" => :arm64_big_sur
    sha256 "63e4c98ff67ce6e8c39dc1cdc96e782328adfbe08c3ee6b420dd75f942dea242" => :catalina
    sha256 "f44412d572c2ae10f1e547ff26f6c01b55609ebe34fdc4fe78be18e4ef7bb0b5" => :mojave
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
