class Stegsnow < Formula
  desc "Used to conceal messages in ASCII text by appending whitespace"
  homepage "https://www.darkside.com.au/snow"
  url "https://github.com/willi123yao/stegsnow/archive/20130616.tar.gz"
  sha256 "49179a21a2892297053db3d7ef41e00c83dbebea30c472487a6d3975b877ebc8"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/willi123yao/homebrew-repo/releases/download/stegsnow-20130616"
    sha256 cellar: :any_skip_relocation, big_sur:      "776369cf99297d83a815ac7e6df767633f136592c97e94e578e326311dfe1aad"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ac0ffc5edb497d3e4aa7146ac9a051921e01265b72c72599b34f77f46415fbd1"
  end

  patch do
    url "https://aur.archlinux.org/cgit/aur.git/plain/stegsnow.patch?h=stegsnow"
    sha256 "d27d97a950a99f649b705d03ef334fa33bfb76280cb6fcf21a73ad4c0fdcaafc"
  end

  def install
    system "make"
    bin.install "stegsnow"
  end

  test do
    system bin/"stegsnow", "--version"
  end
end
