class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.6/2.6.10/+download/juju-core_2.6.10.tar.gz"
  sha256 "d781b733dd7a4e74ef0e9f88527a74a4bea0298e56f4dcaa6dd1cf62c2c40f2b"

  bottle do
    cellar :any_skip_relocation
    sha256 "f53bc53815c4cfd697367e007c465fe0bd39b5a70cd12688cc54f594daffeeaf" => :catalina
    sha256 "f904882a0c72ffad08bb0e4b5c97b744c82ee364027b8d99168ca9e3659dc869" => :mojave
    sha256 "7f26bb043ef8cb69589f1746c364cf57499d8c354a0f6c8ce083083dab18eb0b" => :high_sierra
  end

  depends_on "go" => :build

  def install
    # Fix for Catalina
    # Backport of https://github.com/juju/juju/pull/10775 and https://github.com/juju/os/pull/14
    # Remove in 2.7
    inreplace Dir["src/github.com/juju/juju/vendor/github.com/juju/{utils,os}/series/series.go"],
      "var macOSXSeries = map[int]string{",
      "var macOSXSeries = map[int]string{\n\t19: \"catalina\","

    ENV["GOPATH"] = buildpath
    system "go", "build", "github.com/juju/juju/cmd/juju"
    system "go", "build", "github.com/juju/juju/cmd/plugins/juju-metadata"
    bin.install "juju", "juju-metadata"
    bash_completion.install "src/github.com/juju/juju/etc/bash_completion.d/juju"
  end

  test do
    system "#{bin}/juju", "version"
  end
end
