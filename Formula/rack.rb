class Rack < Formula
  desc "CLI for Rackspace"
  homepage "https://github.com/rackspace/rack"
  url "https://github.com/rackspace/rack.git",
      tag:      "1.2",
      revision: "09c14b061f4a115c8f1ff07ae6be96d9b11e08df"
  license "Apache-2.0"
  head "https://github.com/rackspace/rack.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/rack"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "c20ad45977c51f929d7cf6e8bb332d8131b761a2382216bc5d82b927ff262c5b"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["TRAVIS_TAG"] = version
    ENV["GO111MODULE"] = "auto"

    rackpath = buildpath/"src/github.com/rackspace/rack"
    rackpath.install Dir["{*,.??*}"]

    cd rackpath do
      # This is a slightly grim hack to handle the weird logic around
      # deciding whether to add a = or not on the ldflags, as mandated
      # by Go 1.7+.
      # https://github.com/rackspace/rack/issues/446
      inreplace "script/build", "go1.5", Utils.safe_popen_read("go", "version")[/go1\.\d/]

      ln_s "internal", "vendor"
      system "script/build", "rack"
      bin.install "rack"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/rack"
  end
end
