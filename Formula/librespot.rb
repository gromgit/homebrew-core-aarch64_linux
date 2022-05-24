class Librespot < Formula
  desc "Open Source Spotify client library"
  homepage "https://github.com/librespot-org/librespot"
  url "https://github.com/librespot-org/librespot/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "ae3ce1f3bd0031cac687eb60e08abb2d327ba51623c583765eda70376d69a71f"
  license "MIT"
  head "https://github.com/librespot-org/librespot.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e349b962c526397d8375d0476993ce36069a3cbd852dd65f3fe37419817b2c18"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e7f1a1c2e5365a5ff9cc825462a10588bd9e58a5bff52b9d74065d418b194d72"
    sha256 cellar: :any_skip_relocation, monterey:       "77bebe47dba18f992641a9f83772f3956722e6351c45269e85f75a8433d1bb88"
    sha256 cellar: :any_skip_relocation, big_sur:        "96331e7b6ca400333d6a01f8141edaf9dc8d37ff162ca9e49838779fe4fe273f"
    sha256 cellar: :any_skip_relocation, catalina:       "24299fd61bbae5f98e700336e6a48a109cf7adb0b03a7a56169388cd937a714b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fa28391fc83ff32d0c81826e4998cf4134035c9e2a1efe1b87b01bf638632bc"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "alsa-lib"
    depends_on "avahi"
  end

  def install
    ENV["COREAUDIO_SDK_PATH"] = MacOS.sdk_path.to_s if OS.mac?
    system "cargo", "install", "--no-default-features", "--features", "rodio-backend,with-dns-sd", *std_cargo_args
  end

  test do
    require "open3"
    require "timeout"

    Open3.popen3({ "RUST_LOG" => "DEBUG" }, "#{bin}/librespot", "-v") do |_, _, stderr, wait_thr|
      Timeout.timeout(5) do
        stderr.each do |line|
          refute_match "ERROR", line
          break if line.include? "Zeroconf server listening"
        end
      end
    ensure
      Process.kill("INT", wait_thr.pid)
    end
  end
end
