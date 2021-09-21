class GolangMigrate < Formula
  desc "Database migrations CLI tool"
  homepage "https://github.com/golang-migrate/migrate"
  url "https://github.com/golang-migrate/migrate/archive/v4.15.0.tar.gz"
  sha256 "a8980f00810f5d614f467d80a97598c8ff923e760678f54b173fe9def7811c7f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5eefbb5079926c045bb54d7c39dacdff1f47333537ae117e549a6bf4c0022415"
    sha256 cellar: :any_skip_relocation, big_sur:       "89331be62af8d09c5488f04bbb9e8bbaaf2f8308fc80b33d0460a59aef8fb933"
    sha256 cellar: :any_skip_relocation, catalina:      "9e5042348f5365709904256c67be90eb6c58933ba6718f75f0c6fd43fbc284b0"
    sha256 cellar: :any_skip_relocation, mojave:        "a6d8c96b681088ee7ff2d4e5cf4b486b8731771712bf4ce03234df1a18d5b718"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c830a75556f981d38518261f56847bafe1d478b1180bed16e4cb4a1519827eb5"
  end

  depends_on "go" => :build

  def install
    system "make", "VERSION=v#{version}"
    bin.install "migrate"
  end

  test do
    touch "0001_migtest.up.sql"
    output = shell_output("#{bin}/migrate -database stub: -path . up 2>&1")
    assert_match "1/u migtest", output
  end
end
