class Carthage < Formula
  desc "Decentralized dependency manager for Cocoa"
  homepage "https://github.com/Carthage/Carthage"
  url "https://github.com/Carthage/Carthage.git",
      tag:      "0.35.1",
      revision: "0d324cbd5d3a5b68ec69c84a05ae4a28af95e96f",
      shallow:  false
  license "MIT"
  head "https://github.com/Carthage/Carthage.git", shallow: false

  bottle do
    cellar :any_skip_relocation
    sha256 "ecbd3a41f0f0852c2733ce0cff6d8fac21267d742a9fc25b5096bec67f3115a5" => :catalina
    sha256 "9c108d01c9a96de071a981d4aa0c87f3e597c04533f7cdae13ef2390f101d1df" => :mojave
    sha256 "82612126335fdc74315c7d5c713b8114da552d1188dc3c4be1436447545c7a13" => :high_sierra
  end

  depends_on xcode: ["10.0", :build]

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}"
    bash_completion.install "Source/Scripts/carthage-bash-completion" => "carthage"
    zsh_completion.install "Source/Scripts/carthage-zsh-completion" => "_carthage"
    fish_completion.install "Source/Scripts/carthage-fish-completion" => "carthage.fish"
  end

  test do
    (testpath/"Cartfile").write 'github "jspahrsummers/xcconfigs"'
    system bin/"carthage", "update"
  end
end
