class BpmTools < Formula
  desc "Detect tempo of audio files using beats-per-minute (BPM)"
  homepage "https://www.pogo.org.uk/~mark/bpm-tools/"
  url "https://www.pogo.org.uk/~mark/bpm-tools/releases/bpm-tools-0.3.tar.gz"
  sha256 "37efe81ef594e9df17763e0a6fc29617769df12dfab6358f5e910d88f4723b94"
  license "GPL-2.0"
  head "https://www.pogo.org.uk/~mark/bpm-tools.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?bpm-tools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/bpm-tools"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "5555e729d5e9b349f5a5ce48d2bd959208e9f1e564b2a57d809da55912f28056"
  end

  def install
    system "make"
    bin.install "bpm"
    bin.install "bpm-tag"
  end
end
