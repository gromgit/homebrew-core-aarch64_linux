class Corectl < Formula
  desc "CoreOS over OS X made very simple"
  homepage "https://github.com/TheNewNormal/corectl"
  url "https://github.com/TheNewNormal/corectl/archive/v0.5.5.tar.gz"
  sha256 "47bcd42d110f0069dedcd741ea11cb0857cdcf1eaa01c69f2cdea6847d130ee6"
  head "https://github.com/TheNewNormal/corectl.git", :branch => "golang"

  bottle do
    cellar :any_skip_relocation
    sha256 "33362faf630a3680740ac2dd5b34bf24958de0a2f9e157605bc9ce199905df49" => :el_capitan
    sha256 "6f53ededba4f9057e0d0d00a71c1c658aeabfa250d65570beb12bfa2228ced51" => :yosemite
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
      inreplace "utils.go", "engine.pwd+\"/", "\""
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
