class Macchina < Formula
  desc "System information fetcher, with an emphasis on performance and minimalism"
  homepage "https://github.com/Macchina-CLI/macchina"
  url "https://github.com/Macchina-CLI/macchina/archive/v0.8.1.tar.gz"
  sha256 "21ecc57ecc0f13bdb438d8ec78d3f630084cae7a4b69eea66e8f3ce18b5ab2f6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "83c19fcec41813983af76ca08652d92e8d41e2c0ffba576d1b770ef723429aaa"
    sha256 cellar: :any_skip_relocation, big_sur:       "02d430ad1cbbcdb2fdcf431c974ab895fb52c2dbfbb0c81a5e16690bd4660812"
    sha256 cellar: :any_skip_relocation, catalina:      "247cff88f541eedd51d4a43b5e8e403e8b0dba183ac566d3f8145a7b3dae96aa"
    sha256 cellar: :any_skip_relocation, mojave:        "af7b23e77c68e90efaf35a41ce13c1e7d415c22ca9ea3b495d75564f63c3f423"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Let's check your system for errors...", shell_output("#{bin}/macchina --doctor")
  end
end
