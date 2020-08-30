class Act < Formula
  desc "Run your GitHub Actions locally 🚀"
  homepage "https://github.com/nektos/act"
  url "https://github.com/nektos/act/archive/v0.2.13.tar.gz"
  sha256 "cc9737202a2f148b898473126377e682afeafc4b77945dc9997ee02aa8c8370f"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "55e6427e143a54416051bcefbe4155b40256bf5a3410c83e7a7d4c8433c64960" => :catalina
    sha256 "7f4bf5ccb3fbba61d4a9668edd375f162c0b92f3e0baa0148b7a8c2613d23739" => :mojave
    sha256 "09b823cc2f599888287df90f8a8e8775de2a4e0a0f32fe089cfc5e39d9c99a28" => :high_sierra
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
