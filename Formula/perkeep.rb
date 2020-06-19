class Perkeep < Formula
  desc "Lets you permanently keep your stuff, for life"
  homepage "https://perkeep.org/"

  stable do
    url "https://github.com/perkeep/perkeep.git",
        :tag      => "0.10",
        :revision => "0cbe4d5e05a40a17efe7441d75ce0ffdf9d6b9f5"

    # gopherjs doesn't tag releases, so just pick the most recent revision for now
    resource "gopherjs" do
      url "https://github.com/gopherjs/gopherjs/archive/fce0ec30dd00773d3fa974351d04ce2737b5c4d9.tar.gz"
      sha256 "e5e6ede5f710fde77e48aa1f6a9b75f5afeb1163223949f76c1300ae44263b84"
    end

    depends_on "go@1.12" => :build
  end

  bottle do
    sha256 "1e51d2d991309cec65b66411ff9dbbd1d93ec40c4c595d1b91a786541c15d738" => :mojave
    sha256 "4db15262421ce0cefad97fd2df3affba61cba2e1ba1e4153614940cec138ae10" => :high_sierra
    sha256 "9ab629c218f4af8f769520ec269c81c6499c6c9676c5ae43da8fc7ac8212c0ff" => :sierra
    sha256 "e4e42c68017500af8a8aa7b542e89905849b09b398a547da818323f08a6e680a" => :el_capitan
  end

  head do
    url "https://github.com/perkeep/perkeep.git"

    depends_on "go" => :build
  end

  depends_on "pkg-config" => :build

  conflicts_with "hello", :because => "both install `hello` binaries"

  def install
    if build.stable?
      ENV["GOPATH"] = buildpath
      ENV["CAMLI_GOPHERJS_GOROOT"] = Formula["go@1.12"].opt_libexec

      (buildpath/"src/perkeep.org").install buildpath.children

      # Vendored version of gopherjs requires go 1.10, so use the newest available gopherjs, which
      # supports up to go 1.12
      rm_rf buildpath/"src/perkeep.org/vendor/github.com/gopherjs/gopherjs"
      resource("gopherjs").stage buildpath/"src/perkeep.org/vendor/github.com/gopherjs/gopherjs"

      cd "src/perkeep.org" do
        system "go", "run", "make.go"
      end

      bin.install Dir["bin/*"].select { |f| File.executable? f }
    else
      system "go", "run", "make.go"
      bin.install Dir[".brew_home/go/bin/*"].select { |f| File.executable? f }
    end
  end

  plist_options :manual => "perkeepd"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/perkeepd</string>
          <string>-openbrowser=false</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
      </dict>
      </plist>
    EOS
  end

  test do
    system bin/"pk-get", "-version"
  end
end
