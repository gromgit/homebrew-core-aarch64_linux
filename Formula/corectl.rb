class Corectl < Formula
  desc "CoreOS over OS X made very simple"
  homepage "https://github.com/TheNewNormal/corectl"
  url "https://github.com/TheNewNormal/corectl/archive/v0.5.7.tar.gz"
  sha256 "13afffc3c7352a3a832c1c821aecd9086ca12e7f005a11e213ddc5a068291268"
  head "https://github.com/TheNewNormal/corectl.git", :branch => "golang"

  bottle do
    cellar :any_skip_relocation
    sha256 "3c2ca7e8219ffdccd5c6dbc7587f40cebbf31f91d5b34c6ed8ba6543f4db007c" => :el_capitan
    sha256 "e3cd0c451539fea2e15e358293222e5d751103681640568f40c2a9384b6fc873" => :yosemite
  end

  depends_on "go" => :build
  depends_on "godep" => :build
  depends_on :macos => :yosemite

  def install
    ENV["GOPATH"] = buildpath

    path = buildpath/"src/github.com/TheNewNormal/#{name}"
    path.install Dir["*"]

    args = []
    args << "VERSION=#{version}" if build.stable?

    cd path do
      system "make", "corectl", *args
      system "make", "documentation/man"
      bin.install "corectl"
      man1.install Dir["documentation/man/*.1"]
      share.install "cloud-init", "profiles"
    end
  end

  test do
    assert_match(/#{version}/, shell_output("#{bin}/corectl version"))
  end
end
