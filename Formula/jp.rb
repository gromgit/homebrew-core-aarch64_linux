class Jp < Formula
  desc "Dead simple terminal plots from JSON data"
  homepage "https://github.com/sgreben/jp"
  url "https://github.com/sgreben/jp/archive/1.1.12.tar.gz"
  sha256 "8c9cddf8b9d9bfae72be448218ca0e18d24e755d36c915842b12398fefdc7a64"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/jp"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "ba212c2fde0f5b095011ceb29ae121e7621115d755c939f5ed68e68a01010aea"
  end

  depends_on "go" => :build

  # Fix build on ARM by adding a corresponding Makefile target
  patch :DATA

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    build_root = buildpath/"src/github.com/sgreben/jp"
    build_root.install Dir["*"]
    cd build_root do
      arch = Hardware::CPU.arch.to_s
      os = OS.mac? ? "osx" : OS.kernel_name.downcase
      system "make", "binaries/#{os}_#{arch}/jp"
      bin.install "binaries/#{os}_#{arch}/jp"
    end
  end

  test do
    pipe_output("#{bin}/jp -input csv -xy '[*][0,1]'", "0,0\n1,1\n", 0)
  end
end

__END__
diff --git a/Makefile b/Makefile
index adc9d13..664b6af 100644
--- a/Makefile
+++ b/Makefile
@@ -90,3 +90,10 @@ release/$(APP)_$(VERSION)_linux_arm64.zip: binaries/linux_arm64/$(APP)

 binaries/linux_arm64/$(APP): $(GOFILES)
 	GOOS=linux GOARCH=arm64 go build -ldflags "-X main.version=$(VERSION)" -o binaries/linux_arm64/$(APP) ./cmd/$(APP)
+
+release/$(APP)_$(VERSION)_osx_arm64.zip: binaries/osx_arm64/$(APP)
+	mkdir -p release
+	cd ./binaries/osx_arm64 && zip -r -D ../../release/$(APP)_$(VERSION)_osx_arm64.zip $(APP)
+
+binaries/osx_arm64/$(APP): $(GOFILES)
+	GOOS=darwin GOARCH=arm64 go build -ldflags "-X main.version=$(VERSION)" -o binaries/osx_arm64/$(APP) ./cmd/$(APP)
