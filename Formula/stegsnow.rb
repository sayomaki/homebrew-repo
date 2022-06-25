class Stegsnow < Formula
  desc "Used to conceal messages in ASCII text by appending whitespace"
  homepage "https://www.darkside.com.au/snow"
  url "https://github.com/willi123yao/stegsnow/archive/20130616.tar.gz"
  sha256 "49179a21a2892297053db3d7ef41e00c83dbebea30c472487a6d3975b877ebc8"
  license "Apache-2.0"

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
