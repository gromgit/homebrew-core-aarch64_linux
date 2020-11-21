class GolangMigrate < Formula
  desc "Database migrations CLI tool"
  homepage "https://github.com/golang-migrate/migrate"
  url "https://github.com/golang-migrate/migrate/archive/v4.14.0.tar.gz"
  sha256 "fdd72511531e73d0f9c94143269d787df338a00720d910dc6132e630e3cae709"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "c307583e30cca29afa47e39a03420c03c3c2f8d8e47caeffa65c9c9ec549be1a" => :big_sur
    sha256 "7b3f17ad67ed952e5610a2652d3bc55dba883c14571bbc2f8c8219bdb6a7a406" => :catalina
    sha256 "b138f2dbe7a558a0c2c3595e2ff30c33b9a25351f63a2140fc406f5b00a94d66" => :mojave
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
